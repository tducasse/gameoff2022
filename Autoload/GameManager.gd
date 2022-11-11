extends Node

const json = preload("res://Utils/json.gd")

# warning-ignore:unused_signal
signal turn_changed(turn)

var cards_per_turn = 4

var cards = []

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
	var cards_json = json.load_json_file("res://Assets/Cards/cards.json")
	if cards_json:
		cards = cards_json

