extends MarginContainer

onready var Hero = preload("res://States/Fight/Hero.tscn")
onready var List = $List


# Called when the node enters the scene tree for the first time.
func _ready():
	for hero in gm.hired_heroes:
		add_hero(hero)


func add_hero(hero):
	var hero_instance = Hero.instance()
	List.add_child(hero_instance)
	hero_instance.init(hero)
