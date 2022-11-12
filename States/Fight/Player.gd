extends HBoxContainer

onready var Hand = $Hand
onready var EndTurn = $Right/CenterContainer/EndTurn
onready var StartTurn = $Left/CenterContainer/StartTurn

func _ready():
	show_actions()
	var _signal = gm.connect("turn_changed", self, "_handle_next_turn")


func show_actions():
	if gm.is_player_turn():
		EndTurn.show()
		StartTurn.hide()
	else:
		EndTurn.hide()
		StartTurn.show()


func _handle_next_turn(_turn):
	show_actions()
	

func _on_EndTurn_pressed():
	Hand.discard()
	gm.end_turn()


func _on_StartTurn_pressed():
	# TODO: end enemy's turn
	gm.end_turn()
	Hand.new_turn()
