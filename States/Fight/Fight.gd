extends MarginContainer


onready var Enemy = $VBoxContainer/Field/Enemy


var enemy = null

func init(params):
	enemy = pick_random_monster(params.value)
	Enemy.init(enemy)


func pick_random_monster(options):
	if len(options) < 1:
		return
	var monster = options[randi() % options.size()]
	return gm.monsters.get(monster).duplicate()
