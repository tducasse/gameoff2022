extends Node

const json = preload("res://Utils/json.gd")
onready var Map = preload("res://States/Map/Map.tscn")
onready var Menu = preload("res://States/Menu/Menu.tscn")

# warning-ignore:unused_signal
signal turn_changed(turn)
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
signal monster_dead(val)


var cards_per_turn = 4
var starting_mana = 3
var starting_hp = 10
var starting_armor = 0

var cards = {}
var decks = {}
var deck = []
var map = []
var monsters = {}
var actions = {}
var edges = []

var current_hp = 0
var current_armor = 0
var current_mana = 0
var completed = []
var current_level_index = 0

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
	emit_signal("turn_changed", current_turn)


func is_player_turn():
	return current_turn == PLAYER.SELF


func _ready():
	cards = json.load_json_file("res://Assets/Cards/cards.json")
	decks = json.load_json_file("res://Assets/Cards/decks.json")
	monsters = json.load_json_file("res://Assets/Monsters/monsters.json")
	actions = json.load_json_file("res://Assets/Monsters/actions.json")
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


func make_map():
	var nodes = json.load_json_file("res://Assets/Map/nodes.json")
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
	current_hp = starting_hp
	gm.completed= []
	emit_signal("hp_changed")


func start_fight():
	current_turn = PLAYER.SELF
	current_mana = starting_mana
	current_armor = starting_armor
	emit_signal("mana_changed")
	emit_signal("turn_changed", current_turn)


func play_attack_card(card):
	var dmg = card.get("other", {}).get("damage")
	var self_dmg = card.get("self", {}).get("damage")
	if dmg:
		emit_signal("damage_monster", dmg)
	if self_dmg:
		emit_signal("damage_player", self_dmg)



func play_skill_card(card):
	var armor = card.get("self", {}).get("armor")
	var self_dmg = card.get("self", {}).get("damage")
	var dmg = card.get("other", {}).get("damage")
	if dmg:
		emit_signal("damage_monster", dmg)
	if self_dmg:
		emit_signal("damage_player", self_dmg)
		take_damage(self_dmg)
	if armor:
		emit_signal("armor_player", armor)
		add_armor(armor)


func add_armor(armor):
	current_armor = current_armor + armor
	emit_signal("armor_changed")
	

func take_damage(dmg):
	var remaining_damage = clamp(dmg - current_armor, 0, dmg)
	var remaining_armor = clamp(current_armor - dmg, 0, current_armor)
	current_armor = remaining_armor
	current_hp = clamp(current_hp - remaining_damage, 0, current_hp)
	if current_hp == 0:
		return player_dead()
	emit_signal("hp_changed")
	emit_signal("armor_changed")


func _on_card_played(card):
	if card.type == "attack":
		return play_attack_card(card)
	if card.type == "skill":
		return play_skill_card(card)


func player_dead():
	var menu_instance = Menu.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Fight")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(menu_instance)


func _on_monster_dead():
	completed.append(current_level_index)
	var map_instance = Map.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Fight")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(map_instance)
	map_instance.init()
