extends MarginContainer

signal node_clicked(node_params)
onready var Monster = preload("res://States/Map/Monster.tscn")
onready var Overlay = $Overlay

var params = {}
var node = null


func _ready():
	Overlay.hide()


func init(config):
	params = config
	if params.type == "monster":
		node = Monster.instance()
		var _signal = node.connect("clicked", self, "_on_node_clicked")
	if node:
		add_child(node)


func _on_node_clicked():
	emit_signal("node_clicked", params)
	

func mark_as_complete():
	remove_child(node)
	Overlay.show()
