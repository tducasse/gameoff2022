extends Node

const json = preload("res://Utils/json.gd")

# warning-ignore:unused_signal
signal turn_changed(turn)

# warning-ignore:unused_signal
signal card_played(params)

# warning-ignore:unused_signal
signal mana_changed()

var cards_per_turn = 4
var starting_mana = 3
var current_mana = 0

var cards = {}
var decks = {}
var deck = []
var map = []
var monsters = {}
var actions = {}

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
