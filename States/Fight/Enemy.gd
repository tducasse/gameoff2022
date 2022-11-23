extends VBoxContainer


onready var Name = $VBoxContainer/VBoxContainer/Name
onready var NextAction = $VBoxContainer/VBoxContainer/NextAction
onready var HP = $VBoxContainer/VBoxContainer/HP
onready var Armor = $VBoxContainer/VBoxContainer/Armor
onready var Picture = $VBoxContainer/PictureContainer/Picture
onready var Status = $VBoxContainer/VBoxContainer/Status




signal monster_dead(last)

var monster = {}
var status = {}

var next_action = null
var nb_turn = 1

func _ready():
	var _signal = gm.connect("turn_changed", self, "_on_turn_changed")
	_signal = gm.connect("damage_monster", self, "take_damage")
	_signal = gm.connect("armor_monster", self, "add_armor")
	_signal = gm.connect("status_monster", self, "add_status")


func init(params):
	monster = params
	Name.text = monster.name
	monster.armor = 0
	Picture.texture = load("res://Assets/Monsters/Images/" + str(monster.image))
	update_hp(false)
	update_armor(false)
	update_status(false)


func update_hp(b=true):
	HP.text = "HP: " + str(monster.hp)
	if b:
		blink(HP, "en_hp")


func update_armor(b=true):
	Armor.text = "Armor: " + str(monster.armor)
	if b:
		blink(Armor, "en_armor")


func update_status(b=true):
	var status_text = ""
	if !status.empty() :
		for i in status:
			status_text += i + " " + str(status[i])
	Status.text = status_text
	if b:
		blink(Status, "en_status")


func blink(node, stat):
	gm.blink(node, stat)


func _on_turn_changed():
	if not gm.is_player_turn():
		# TODO: replace with an animation
		var tree = weakref(get_tree())
		if not tree.get_ref():
			return
		yield(tree.get_ref().create_timer(0.5), "timeout")
		do_action()
		if gm.current_hp == 0:
			return
		# TODO: replace with an animation
		tree = weakref(get_tree())
		if not tree.get_ref():
			return
		yield(tree.get_ref().create_timer(0.5), "timeout")
		end_turn()
		
	else:
		nb_turn = nb_turn + 1
		plan_action()
		advertise_action()


func advertise_action():
	var armor = next_action.get("self", {}).get("armor")
	var dmg = next_action.get("other", {}).get("damage")
	if dmg:
		NextAction.text = "Next action: " + str(dmg) + " dmg"
	if armor:
		NextAction.text = "Next action: " + str(armor) + " armor"


func do_action():
	if not next_action:
		return
	var armor = next_action.get("self", {}).get("armor")
	var self_dmg = next_action.get("self", {}).get("damage")
	var dmg = next_action.get("other", {}).get("damage")
	var sfx = next_action.get("sfx")
	if sfx:
		Sounds.play_sfx(gm.sfx[next_action.id])
	if dmg:
		gm.emit_signal("damage_player", dmg)
	if self_dmg:
		take_damage(self_dmg)
	if armor:
		add_armor(armor)
	for s in status:
		if s == "bleeding":
			take_damage(status[s])
			status[s] -=1
		if status[s] == 0:
			status.erase(s)
	update_status()
	next_action = null


func end_turn():
	gm.end_turn()


func add_armor(armor):
	monster.armor = monster.armor + armor
	update_armor()


func add_status(afflictions):
	for a in afflictions:
		if status.has(a):
			status[a] += afflictions[a]
		else:
			status[a] = afflictions[a]

	update_status()


func plan_action():
	if monster.style == "random":
		plan_random_action()
	elif monster.style == "sequence":
		plan_sequence_action()


func plan_sequence_action():
	var action = monster.actions[nb_turn % len(monster.actions)]
	next_action = gm.actions.get(action).duplicate()
	next_action["id"] = action


func plan_random_action():
	var actions = []
	for action in monster.actions:
		for _i in range(action.weight):
			actions.append(action.id)
	if len(actions) < 1:
		return
	var action = actions[randi() % actions.size()]
	next_action = gm.actions.get(action).duplicate()
	next_action["id"] = action


func take_damage(dmg):
	var had_armor = monster.armor
	var remaining_damage = clamp(dmg - monster.armor, 0, dmg)
	var remaining_armor = clamp(monster.armor - dmg, 0, monster.armor)
	monster.armor = remaining_armor
	monster.hp = clamp(monster.hp - remaining_damage, 0, monster.hp)
	if monster.hp == 0:
		emit_signal("monster_dead", monster.get("last"))
	if monster.armor == 0:
		update_hp()
	if had_armor:
		update_armor()

