extends MarginContainer


onready var Map = preload("res://States/Map/Map.tscn")


func _ready():
	  randomize()


func _on_Start_pressed():
	var map_instance = Map.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Menu")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(map_instance)
