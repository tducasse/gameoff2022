extends VBoxContainer


onready var Name = $HBoxContainer/VBoxContainer/Name
onready var NextAction = $HBoxContainer/VBoxContainer/NextAction
onready var HP = $HBoxContainer/VBoxContainer/HP
onready var Armor = $HBoxContainer/VBoxContainer/Armor
onready var Image = $HBoxContainer/Image

signal monster_dead(last)

var monster = {}

var next_action = null
var nb_turn = 1

func _ready():
	var _signal = gm.connect("turn_changed", self, "_on_turn_changed")
	_signal = gm.connect("damage_monster", self, "take_damage")
	_signal = gm.connect("armor_monster", self, "add_armor")


func init(params):
	monster = params
	Name.text = monster.name
	monster.armor = 0
	Image.texture = load("res://Assets/Monsters/Images/" + str(monster.image))
	update_hp()
	update_armor()


func update_hp():
	HP.text = "HP: " + str(monster.hp)


func update_armor():
	Armor.text = "Armor: " + str(monster.armor)


func _on_turn_changed():
	if not gm.is_player_turn():
		do_action()
		if gm.current_hp == 0:
			return
		# TODO: replace with an animation
		yield(get_tree().create_timer(1), "timeout")
		end_turn()
		nb_turn = nb_turn + 1
	else:
		plan_action()
		advertise_action()


func advertise_action():
	NextAction.text = "Next action: " + next_action.name


func do_action():
	if not next_action:
		return
	var armor = next_action.get("self", {}).get("armor")
	var self_dmg = next_action.get("self", {}).get("damage")
	var dmg = next_action.get("other", {}).get("damage")
	if dmg:
		gm.emit_signal("damage_player", dmg)
	if self_dmg:
		take_damage(self_dmg)
	if armor:
		add_armor(armor)
	next_action = null


func end_turn():
	gm.end_turn()


func add_armor(armor):
	monster.armor = monster.armor + armor
	update_armor()


func plan_action():
	if monster.style == "random":
		plan_random_action()
	elif monster.style == "sequence":
		plan_sequence_action()


func plan_sequence_action():
	next_action = gm.actions.get(monster.actions[nb_turn % len(monster.actions)]).duplicate()


func plan_random_action():
	var actions = []
	for action in monster.actions:
		for _i in range(action.weight):
			actions.append(action.id)
	if len(actions) < 1:
		return
	var action = actions[randi() % actions.size()]
	next_action =  gm.actions.get(action).duplicate()




func take_damage(dmg):
	var remaining_damage = clamp(dmg - monster.armor, 0, dmg)
	var remaining_armor = clamp(monster.armor - dmg, 0, monster.armor)
	monster.armor = remaining_armor
	monster.hp = clamp(monster.hp - remaining_damage, 0, monster.hp)
	if monster.hp == 0:
		emit_signal("monster_dead", monster.get("last"))
	update_armor()
	update_hp()

