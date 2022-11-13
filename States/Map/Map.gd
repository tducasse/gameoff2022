extends MarginContainer

onready var Grid = $CenterContainer/GridContainer

onready var Fight = preload("res://States/Fight/Fight.tscn")
onready var MapNode = preload("res://States/Map/MapNode.tscn")

func _ready():
	init_map()


func init_map():
	for i in range(45):
		var map_node = MapNode.instance()
		Grid.add_child(map_node)
		var node_val = gm.map[i]
		if node_val:
			node_val.index = i
			map_node.init(node_val)
			map_node.connect("node_clicked", self, "_on_node_clicked")


func init():
	var children = Grid.get_children()
	for level in gm.completed:
		var index = int(level)
		children[index].mark_as_complete()


func _on_node_clicked(params):
	gm.current_level_index = params.index
	if params.type == "monster":
		_on_monster_clicked(params)


func _on_monster_clicked(params):
	var fight_instance = Fight.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Map")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(fight_instance)
	fight_instance.init(params)

