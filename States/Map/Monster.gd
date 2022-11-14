extends MarginContainer

signal clicked()

onready var PictureContainer = $PictureContainer
onready var Picture = $PictureContainer/Picture


func _ready():
	var scale = PictureContainer.get_rect().size.x / Picture.texture.get_size().x
	Picture.scale.x = scale
	Picture.scale.y = scale


func _on_Overlay_gui_input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		emit_signal("clicked")
