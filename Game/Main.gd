extends Node2D

onready var card_manager = preload("res://CardManager/Manager.tscn")
onready var CardManagerButton = $CardManager

func _ready():
	CardManagerButton.hide()
	# Project > Export > Uncheck "Run with Debug" to compile in release mode
	if OS.is_debug_build():
		CardManagerButton.show()

func _on_CardManager_pressed():
	var manager_instance = card_manager.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Main")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(manager_instance)
