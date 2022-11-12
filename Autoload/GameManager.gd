extends Node

const json = preload("res://Utils/json.gd")

# warning-ignore:unused_signal
signal turn_changed(turn)

var cards_per_turn = 4
var starting_mana = 3

var cards = {}
var decks = {}
var deck = []

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
	gm.emit_signal("turn_changed", current_turn)


func is_player_turn():
	return current_turn == PLAYER.SELF


func _ready():
	cards = json.load_json_file("res://Assets/Cards/cards.json")
	decks = json.load_json_file("res://Assets/Cards/decks.json")
	make_deck(decks, cards, "default")


func make_deck(all_decks, all_cards, deck_name):
	var deck_obj = all_decks.get(deck_name)
	for card in deck_obj.cards:
		for _i in range(card.number):
			deck.append(all_cards.get(card.id))
