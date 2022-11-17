extends MarginContainer


onready var Enemy = $VBoxContainer/Field/Enemy


var enemy = null

func init(params):
	enemy = pick_random_monster(params.value)
	Enemy.init(enemy)
	gm.start_fight()


func pick_random_monster(options):
	if len(options) < 1:
		return
	var monster = options[randi() % options.size()]
	return gm.monsters.get(monster).duplicate()


func _on_Enemy_monster_dead(last):
	gm.emit_signal("monster_dead", last)
