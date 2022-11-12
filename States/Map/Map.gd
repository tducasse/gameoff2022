extends MarginContainer


onready var Path1 = $CenterContainer/Path1
onready var Path2 = $CenterContainer/Path2
onready var Path3 = $CenterContainer/Path3
onready var Fight = preload("res://States/Fight/Fight.tscn")
onready var Monster = preload("res://States/Map/Monster.tscn")

func _ready():
	var monster_instance_1 = Monster.instance()
	var monster_instance_2 = monster_instance_1.duplicate()
	var monster_instance_3 = monster_instance_1.duplicate()
	var _monster_clicked_connection = monster_instance_1.connect("monster_clicked", self, "_on_monster_clicked")
	_monster_clicked_connection = monster_instance_2.connect("monster_clicked", self, "_on_monster_clicked")
	_monster_clicked_connection = monster_instance_3.connect("monster_clicked", self, "_on_monster_clicked")
	Path1.add_child(monster_instance_1)
	Path2.add_child(monster_instance_2)
	Path3.add_child(monster_instance_3)


func _on_monster_clicked():
	var fight_instance = Fight.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Map")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(fight_instance)

