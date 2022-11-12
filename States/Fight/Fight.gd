extends MarginContainer


onready var Mana = $VBoxContainer/MarginContainer/Mana


func _ready():
	Mana.text = str(gm.starting_mana)
