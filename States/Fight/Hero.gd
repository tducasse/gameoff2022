extends MarginContainer


onready var Name = $VBoxContainer/Name
onready var Power = $VBoxContainer/Power

var hero = {}


func init(params):
	hero = params
	Name.text = hero.name
	attach_power()
	Power.hide()


func attach_power():
	if hero.power.when.get("frequency"):
		var _signal = gm.connect("turn_changed", self, "_on_turn_changed")


func _on_turn_changed():
	if gm.is_player_turn():
		if gm.nb_player_turns % int(hero.power.when.frequency) == 0:
			return Power.show()
	Power.hide()


func activate_power():
	if hero.power.type == "armor":
		add_armor(hero.power.value)
	elif hero.power.type == "card":
		draw_card(hero.power.value)


func _on_Power_pressed():
	activate_power()
	Power.hide()


func add_armor(armor):
	gm.add_armor(armor)


func draw_card(card):
	gm.draw_card(card)
