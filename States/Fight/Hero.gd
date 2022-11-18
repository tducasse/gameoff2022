extends MarginContainer


onready var Picture = $HBoxContainer/PictureContainer/Picture
onready var Cooldown = $HBoxContainer/PictureContainer/Picture/Cooldown

const hero_utils = preload("res://Utils/hero_utils.gd")

var hero = {}
var counter = 0
var do_not_reset = false
var disabled = true

func init(params):
	disable_power()
	Picture.texture = load("res://Assets/Heroes/Images/" + params.image)
	hero = params
	Picture.hint_tooltip = hero_utils.get_power_string(hero.power)
	counter = hero.power.when.frequency
	attach_power()


func disable_power():
	if counter > 0:
		Picture.self_modulate = Color("4a4545")
		Cooldown.text = str(counter)
		disabled = true


func enable_power():
	Picture.self_modulate = Color(1,1,1,1)
	Cooldown.text = ""
	disabled = false
	do_not_reset = true


func attach_power():
	if hero.power.when.get("frequency"):
		var _signal = gm.connect("turn_changed", self, "_on_turn_changed")


func _on_turn_changed():
	if gm.is_player_turn():
		update_counter()
		if counter == 0:
			return enable_power()
	return disable_power()


func reset_counter():
	counter = hero.power.when.get("frequency")
	do_not_reset = false


func update_counter():
	if do_not_reset:
		return
	counter = counter - 1


func activate_power():
	if hero.power.type == "armor":
		add_armor(hero.power.value)
	elif hero.power.type == "card":
		draw_card(hero.power.value)
	reset_counter()


func add_armor(armor):
	gm.add_armor(armor)


func draw_card(card):
	gm.draw_card(card)



func _on_Picture_gui_input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		if not disabled:
			activate_power()
			disable_power()
