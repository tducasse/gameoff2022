extends MarginContainer

onready var Name = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/Name
onready var Picture = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/PictureContainer/Picture
onready var Cost = $ColorRect/MarginContainer/VBoxContainer/Cost
onready var PictureContainer = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/PictureContainer


signal card_clicked

var params = null

func init(config):
	params = config
	Name.text = str(params.name)
	Cost.text = str(params.cost)
	Picture.texture = load("res://Assets/Cards/Images/" + str(params.image))
	var scale = PictureContainer.get_rect().size.x / Picture.texture.get_size().x
	Picture.scale.x = scale
	Picture.scale.y = scale



func _on_Clickable_gui_input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		emit_signal("card_clicked")
