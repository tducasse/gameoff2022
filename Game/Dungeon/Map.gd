extends MarginContainer


onready var Fight = preload("res://Game/Fight/Cave.tscn")


func _on_Fight_pressed():
	var fight_instance = Fight.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Map")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(fight_instance)
