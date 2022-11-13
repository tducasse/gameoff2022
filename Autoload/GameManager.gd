extends Node

const json = preload("res://Utils/json.gd")

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

var cards_per_turn = 4
var starting_mana = 3
var current_mana = 0

var cards = {}
var decks = {}
var deck = []
var map = []
var monsters = {}
var actions = {}
var starting_hp = 100
var current_hp = starting_hp
var current_armor = 0

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


func make_deck(all_decks, all_cards, deck_name):
	var deck_obj = all_decks.get(deck_name)
	for card in deck_obj.cards:
		for _i in range(card.number):
			deck.append(all_cards.get(card.id))


func make_map():
	var nodes = json.load_json_file("res://Assets/Map/nodes.json")
	var layout = json.load_json_file("res://Assets/Map/map.json")
	for i in range(len(layout)):
		for j in range(len(layout[i])):
			if layout[i][j] == 1:
				var index = str(i + 1) + "-" + str(j + 1)
				map.append(nodes.get(index))
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


func start_fight():
	current_turn = PLAYER.SELF
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
	emit_signal("hp_changed")
	emit_signal("armor_changed")


func _on_card_played(card):
	if card.type == "attack":
		return play_attack_card(card)
	if card.type == "skill":
		return play_skill_card(card)
