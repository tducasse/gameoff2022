extends MarginContainer


onready var Name = $Name

var stats = {}


func init(params):
	stats = params
	Name.text = params.name
