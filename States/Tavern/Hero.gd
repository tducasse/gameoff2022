extends MarginContainer

onready var Name = $Stats/Name
onready var Power = $Stats/Power
onready var Picture = $Stats/PictureContainer/Picture
const hero_utils = preload("res://Utils/hero_utils.gd")

signal select_hero(hero)


var hero = {}


func init(params):
	hero = params
	Name.text = hero.name
	Picture.texture = load("res://Assets/Heroes/Images/" + params.image)
	Power.text = hero_utils.get_power_string(hero.power)


func _on_Select_pressed():
	emit_signal("select_hero", hero)

