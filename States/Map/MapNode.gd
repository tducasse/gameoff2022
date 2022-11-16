extends CenterContainer

signal node_clicked(node_params)
onready var Monster = preload("res://States/Map/Monster.tscn")
onready var Tavern = preload("res://States/Map/Tavern.tscn")
onready var Overlay = $Overlay
onready var Available = $Available
onready var Unavailable = $Unavailable
onready var ImageContainer = $ImageContainer

var params = {}
var node = null
var active = false
var complete = false
var starter = false


func _ready():
	Overlay.hide()
	Available.hide()
	Unavailable.hide()


func init(config):
	params = config
	starter = params.get("starter")
	if params.type == "monster":
		node = Monster.instance()
	if params.type == "tavern":
		node = Tavern.instance()
	if starter:
		mark_as_available()
	else:
		mark_as_unavailable()
	ImageContainer.add_child(node)


func _on_node_clicked():
	emit_signal("node_clicked", params)


func mark_as_complete():
	complete = true
	Unavailable.show()
	Available.hide()
	Overlay.show()


func mark_as_available():
	if not node.is_connected("clicked", self, "_on_node_clicked"):
		var _signal = node.connect("clicked", self, "_on_node_clicked")
	Available.show()
	Unavailable.hide()
	active = true

func mark_as_unavailable():
	Unavailable.show()
