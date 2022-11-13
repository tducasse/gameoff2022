extends MarginContainer


onready var Name = $VBoxContainer/Name
onready var NextAction = $VBoxContainer/NextAction

var monster = {}

var next_action = null
var nb_turn = 1

func _ready():
	var _signal = gm.connect("turn_changed", self, "_on_turn_changed")


func init(params):
	monster = params
	Name.text = monster.name


func _on_turn_changed(_turn):
	if not gm.is_player_turn():
		do_action()
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
	print("Monster is using: " + next_action.name)
	next_action = null


func end_turn():
	gm.end_turn()
	

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

