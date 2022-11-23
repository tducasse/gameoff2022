extends Node

const json = preload("res://Utils/json.gd")
onready var Map = preload("res://States/Map/Map.tscn")
onready var Menu = preload("res://States/Menu/Menu.tscn")
onready var meep_merp = preload("res://Assets/Cards/SFX/meep-merp.ogg")

# warning-ignore:unused_signal
signal turn_changed()
# warning-ignore:unused_signal
signal card_played(params)
# warning-ignore:unused_signal
signal mana_changed()
# warning-ignore:unused_signal
signal hp_changed()
# warning-ignore:unused_signal
signal armor_changed()
# warning-ignore:unused_signal
signal armor_player(val)
# warning-ignore:unused_signal
signal damage_player(val)
# warning-ignore:unused_signal
signal damage_monster(val)
# warning-ignore:unused_signal
signal armor_monster(val)
# warning-ignore:unused_signal
signal status_monster(val)
# warning-ignore:unused_signal
signal monster_dead(last)
#warning-ignore:unused_signal
signal draw_card(name)
#warning-ignore:unused_signal
signal card_count_updated()
#warning-ignore:unused_signal
signal player_won()
#warning-ignore:unused_signal
signal player_lost()



var blinking = {
	"en_armor": false,
	"en_hp": false,
	"en_status": false,
	"p_armor": false,
	"p_hp": false,
	"p_mana": false,
}

var cards_per_turn = 4
var starting_mana = 3
var starting_hp = 50
var starting_armor = 0

var cards = {}
var decks = {}
var nodes = {}
var deck = []
var map = []
var monsters = {}
var actions = {}
var edges = []
var heroes = {}
var sfx = {}

var hired_heroes = []

var current_hp = 0
var max_hp = starting_hp
var current_armor = 0
var current_mana = 0
var in_hand = []
var completed = {"indexes": [], "names": []}
var current_level_key = ""
var current_level_index = 0
var nb_player_turns = 1
var current_cards_discarded = []
var current_cards_left = []

enum PLAYER {
	SELF,
	OTHER
}

var current_turn = PLAYER.OTHER

func end_turn():
	if current_turn == PLAYER.SELF:
		current_turn = PLAYER.OTHER
	else:
		current_turn = PLAYER.SELF
		update_mana(starting_mana)
		current_armor = 0
		emit_signal("armor_changed")
	if current_turn == PLAYER.SELF:
		nb_player_turns = nb_player_turns + 1
	emit_signal("turn_changed")


func is_player_turn():
	return current_turn == PLAYER.SELF


func _ready():
	cards = json.load_json_file("res://Assets/Cards/cards.json")
	decks = json.load_json_file("res://Assets/Cards/decks.json")
	monsters = json.load_json_file("res://Assets/Monsters/monsters.json")
	actions = json.load_json_file("res://Assets/Monsters/actions.json")
	heroes = json.load_json_file("res://Assets/Heroes/heroes.json")
	for key in actions.keys():
		var sound = actions[key].get("sfx")
		if sound:
			sfx[key] = load("res://Assets/Cards/SFX/" + sound)
	make_map()
	make_deck(decks, cards, "default")
	update_mana(starting_mana)
	var _s1 = connect("card_played", self, "_on_card_played")
	var _s2 = connect("damage_player", self, "take_damage")
	var _s3 = connect("monster_dead", self, "_on_monster_dead")


func make_deck(all_decks, all_cards, deck_name):
	var deck_obj = all_decks.get(deck_name)
	for card in deck_obj.cards:
		for _i in range(card.number):
			deck.append(all_cards.get(card.id))
	current_cards_left = deck.duplicate()


func shuffle():
	current_cards_left = deck.duplicate()
	for card in in_hand:
		current_cards_left.remove(current_cards_left.find(card))
	current_cards_discarded = []
	emit_signal("card_count_updated")


func make_map():
	nodes = json.load_json_file("res://Assets/Map/nodes.json")
	var map_json = json.load_json_file("res://Assets/Map/map.json")
	var layout = map_json.map
	edges = map_json.edges
	for i in range(len(layout)):
		for j in range(len(layout[i])):
			var val = layout[i][j]
			if val != '-':
				var node = nodes.get(val)
				node.name = val
				map.append(node)
			else:
				map.append(null)


func has_mana_left():
	return current_mana > 0


func has_enough_mana(cost):
	return current_mana >= cost


func update_mana(value):
	current_mana = value
	emit_signal("mana_changed")


func spend_mana(cost):
	if has_enough_mana(cost):
		update_mana(current_mana - cost)


func start_game():
	hired_heroes = []
	current_hp = starting_hp
	completed.indexes = []
	completed.names = []
	max_hp = starting_hp
	emit_signal("hp_changed")


func start_fight():
	current_turn = PLAYER.SELF
	current_mana = starting_mana
	current_armor = starting_armor
	reset_hand()
	shuffle()
	nb_player_turns = 1
	emit_signal("mana_changed")
	emit_signal("turn_changed")


func play_attack_card(card):
	var dmg = card.get("other", {}).get("damage")
	var self_dmg = card.get("self", {}).get("damage")
	var status = card.get("other", {}).get("status")
	var times = card.get("times", {})
	if !times:
		times = 1
	for _i in range(times):
		if dmg:
			emit_signal("damage_monster", dmg)
		if self_dmg:
			emit_signal("damage_player", self_dmg)
		if status:
			emit_signal("status_monster", status)



func play_skill_card(card):
	var self_armor = card.get("self", {}).get("armor")
	var armor = card.get("other", {}).get("armor")
	var self_dmg = card.get("self", {}).get("damage")
	var dmg = card.get("other", {}).get("damage")
	if dmg:
		emit_signal("damage_monster", dmg)
	if self_dmg:
		emit_signal("damage_player", self_dmg)
		take_damage(self_dmg)
	if armor:
		emit_signal("armor_monster", armor)
	if self_armor:
		emit_signal("armor_player", self_armor)
		add_armor(self_armor)


func add_armor(armor):
	current_armor = current_armor + armor
	emit_signal("armor_changed")


func take_damage(dmg):
	var had_armor = current_armor
	var remaining_damage = clamp(dmg - current_armor, 0, dmg)
	var remaining_armor = clamp(current_armor - dmg, 0, current_armor)
	current_armor = remaining_armor
	current_hp = clamp(current_hp - remaining_damage, 0, current_hp)
	if current_hp == 0:
		return player_dead()
	if current_armor == 0:
		emit_signal("hp_changed")
	if had_armor:
		emit_signal("armor_changed")


func _on_card_played(card):
	if card.type == "attack":
		play_attack_card(card)
	elif card.type == "skill":
		play_skill_card(card)


func remove_from_deck(card):
	var index = -1
	for i in range(len(current_cards_left)):
		var c = current_cards_left[i]
		if c.name == card.name:
			index = i
			break
	if index > -1:
		current_cards_left.remove(index)
		in_hand.append(card)
		emit_signal("card_count_updated")


func discard(card):
	var index = -1
	for i in range(len(in_hand)):
		var c = in_hand[i]
		if c.name == card.name:
			index = i
			break
	if index > -1:
		in_hand.remove(index)
		current_cards_discarded.append(card)
		emit_signal("card_count_updated")


func reset_hand():
	in_hand = []
	emit_signal("card_count_updated")


func player_dead():
	var menu_instance = Menu.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Fight")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(menu_instance)
	emit_signal("player_dead")


func _on_monster_dead(last):
	completed.indexes.append(current_level_index)
	completed.names.append(current_level_key)
	if last:
		var menu_instance = Menu.instance()
		var root_node = get_tree().get_root()
		var main_node = get_node("/root/Fight")
		root_node.remove_child(main_node)
		main_node.call_deferred("free")
		root_node.add_child(menu_instance)
		emit_signal("player_win")
		return
	var map_instance = Map.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Fight")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(map_instance)
	map_instance.init()


func select_hero(hero):
	hired_heroes.append(hero)


func _on_hero_selected():
	completed.indexes.append(current_level_index)
	completed.names.append(current_level_key)
	var map_instance = Map.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Tavern")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(map_instance)
	map_instance.init()


func draw_card(name):
	emit_signal("draw_card", name)


func add_card_to_deck(name):
	var card = cards[name].duplicate()
	deck.append(card)


func get_reward_hp(hp):
	current_hp = clamp(current_hp + hp, 0, max_hp)



func blink(node, stat):
	if blinking[stat]:
		return
	blinking[stat] = true
	for _i in range(4):
		if not node:
			blinking[stat] = false
			return
		if node and (node.modulate == Color(1,1,1,1)):
			node.modulate = Color(1,0,0,1)
		else:
			if node:
				node.modulate = Color(1,1,1,1)
		var tree = get_tree()
		if not tree:
			return
		yield(get_tree().create_timer(0.2), "timeout")
	blinking[stat] = false
