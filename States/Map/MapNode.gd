extends MarginContainer

signal node_clicked(node_params)
onready var Monster = preload("res://States/Map/Monster.tscn")

var params = {}


func init(config):
	params = config
	var node = null
	if params.type == "monster":
		node = Monster.instance()
		var _signal = node.connect("clicked", self, "_on_node_clicked")
	if node:
		add_child(node)


func _on_node_clicked():
	emit_signal("node_clicked", params)
