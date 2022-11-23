extends MarginContainer


onready var Map = preload("res://States/Map/Map.tscn")
onready var WinLose = $WinLose

func _ready():
	randomize()
	Sounds.play_menu()
	var _signal1 = gm.connect("player_won", self, "on_player_win")
	var _signal2 = gm.connect("player_lost", self, "on_player_lost")
	WinLose.hide()
	WinLose.dialog_text = ""
	WinLose.dialog_autowrap = true
	WinLose.get_close_button().visible = false


func _on_Start_pressed():
	var map_instance = Map.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Menu")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(map_instance)
	gm.start_game()


func on_player_win():
	WinLose.dialog_text = "YOU WON"
	WinLose.popup_centered_clamped(Vector2(320, 200))


func on_player_lose():
	WinLose.dialog_text = "YOU WON"
	WinLose.popup_centered_clamped(Vector2(320, 200))
