extends HBoxContainer

onready var Hand = $Hand
onready var EndTurn = $Right/CenterContainer/EndTurn

func _ready():
	show_actions()
	var _signal = gm.connect("turn_changed", self, "_handle_next_turn")


func show_actions():
	if gm.is_player_turn():
		EndTurn.show()
	else:
		EndTurn.hide()


func _handle_next_turn(_turn):
	show_actions()
	if gm.is_player_turn():
		Hand.new_turn()
	

func _on_EndTurn_pressed():
	Hand.discard()
	gm.end_turn()
