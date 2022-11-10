extends MarginContainer
class_name Card

onready var Name = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/Name
onready var Picture = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/PictureContainer/Picture
onready var Cost = $ColorRect/MarginContainer/VBoxContainer/Cost
onready var PictureContainer = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/PictureContainer


var card = null


func init(params):
	card = params
	Name.text = str(params.name)
	Cost.text = str(params.cost)
	Picture.texture = load("res://Assets/Images/" + str(params.image))
	var scale = PictureContainer.get_rect().size.x / Picture.texture.get_size().x
	Picture.scale.x = scale
	Picture.scale.y = scale
