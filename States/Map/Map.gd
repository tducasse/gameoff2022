extends MarginContainer

onready var Grid = $CenterContainer/GridContainer

onready var Fight = preload("res://States/Fight/Fight.tscn")
onready var MapNode = preload("res://States/Map/MapNode.tscn")
onready var Lines = $Lines


var nodes = {}

func _ready():
	init_map()


func init_map():
	for i in range(45):
		var map_node = MapNode.instance()
		Grid.add_child(map_node)
		var node = gm.map[i]
		if node:
			node.index = i
			map_node.init(node)
			nodes[node.name] = i
			map_node.connect("node_clicked", self, "_on_node_clicked")
	for edge in gm.edges:
		var a = edge[0]
		var b = edge[1]
		var start = get_node_position(nodes[a])
		var end = get_node_position(nodes[b])
		var line = Line2D.new()
		line.points = [start, end]
		Lines.add_child(line)


func get_node_position(index):
	var i = index % 9
	var j = index / 9
	var pos_x = i * (64+50) + (1024 - 9 * 64 - 8 * 50) / 2 + 32
	var pos_y = j * (64+50) + (600 - 5 * 64 - 4 * 50) / 2 + 32
	return Vector2(pos_x, pos_y)


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

