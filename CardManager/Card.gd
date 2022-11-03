extends ColorRect

onready var Name = $Container/Name
onready var Type = $Container/Type

var card = null

signal deleted(uuid)

func init(params):
	card = params
	Name.text = str(params.name)
	Type.text = str(params.type)

func _on_Delete_pressed():
	emit_signal("deleted", card.uuid)
	queue_free()
