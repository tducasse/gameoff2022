extends MarginContainer

onready var Grid = $CenterContainer/GridContainer

onready var Fight = preload("res://States/Fight/Fight.tscn")
onready var Tavern = preload("res://States/Tavern/Tavern.tscn")
onready var MapNode = preload("res://States/Map/MapNode.tscn")
onready var Background = $Background
onready var Lines = $Lines


var nodes = {}

func _ready():
	Background.scale.x = 1024 / Background.texture.get_size().x
	Background.scale.y = 600 / Background.texture.get_size().y
	init_map()
	Sounds.play_map()


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
		line.default_color = Color.black
		line.width = 3
		Lines.add_child(line)


func get_node_position(index):
	var i = index % 9
	var j = index / 9
	var screen_w = 1024
	var screen_h = 600
	var nb_nodes_w = 9
	var nb_nodes_h = 5
	var node_size = 64
	var space = 50
	var pos_x = i * (node_size + space) + get_grid_margin(screen_w, nb_nodes_w, node_size, space)
	var pos_y = j * (node_size + space) + get_grid_margin(screen_h, nb_nodes_h, node_size, space)
	return Vector2(pos_x, pos_y)


func get_grid_margin(length, nb, node_size, space):
	return (length - nb * node_size - (nb - 1) * space) / 2 + (node_size / 2)


func init():
	var children = Grid.get_children()
	for child in children:
		if child.starter:
			child.mark_as_unavailable()
	for level in gm.completed.indexes:
		var index = int(level)
		children[index].mark_as_complete()
	for edge in gm.edges:
		if edge[0] == gm.current_level_key:
			var current = children[nodes[edge[1]]]
			current.mark_as_available()


func _on_node_clicked(params):
	gm.current_level_index = params.index
	gm.current_level_key = params.name
	if params.type == "monster":
		_on_monster_clicked(params)
	if params.type == "tavern":
		_on_tavern_clicked(params)


func _on_monster_clicked(params):
	var fight_instance = Fight.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Map")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(fight_instance)
	fight_instance.init(params)


func _on_tavern_clicked(params):
	var tavern_instance = Tavern.instance()
	var root_node = get_tree().get_root()
	var main_node = get_node("/root/Map")
	root_node.remove_child(main_node)
	main_node.call_deferred("free")
	root_node.add_child(tavern_instance)
	tavern_instance.init(params)

