extends MarginContainer


onready var Name = $Name

var hero = {}


func init(params):
	hero = params
	Name.text = hero.name
