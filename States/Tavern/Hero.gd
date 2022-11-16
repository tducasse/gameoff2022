extends MarginContainer

onready var Name = $Stats/Name
onready var Power = $Stats/Power

signal select_hero(hero)


var hero = {}


func init(params):
	hero = params
	Name.text = hero.name
	Power.text = get_power_string(hero.power)


func _on_Select_pressed():
	emit_signal("select_hero", hero)
	

func get_power_string(power):
	return get_action(power) + " " + get_frequency(power)


func get_action(power):
	if power.type == "armor":
		return "Add " + str(power.value) + " armor"
	if power.type == "card":
		return "Draw 1 " + str(power.value) + " card"
	else:
		return ""
		
		
func get_frequency(power):
	if power.when.get("frequency"):
		if power.when.frequency == 1:
			return "every turn"
		else:
			return "every " + str(power.when.frequency) + " turns"
	else:
		return ""
