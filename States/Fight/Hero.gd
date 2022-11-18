extends MarginContainer


onready var Power = $HBoxContainer/Power
onready var Picture = $HBoxContainer/PictureContainer/Picture

const hero_utils = preload("res://Utils/hero_utils.gd")

var hero = {}
var cooldown_icon = preload("res://Assets/Icons/hourglass.png")
var ready_icon = preload("res://Assets/Icons/checked.png")
var counter = 0
var do_not_reset = false

func init(params):
	disable_power()
	Picture.texture = load("res://Assets/Heroes/Images/" + params.image)
	hero = params
	Picture.hint_tooltip = hero_utils.get_power_string(hero.power)
	counter = hero.power.when.frequency
	attach_power()


func disable_power():
	if counter > 0:
		Power.icon = cooldown_icon
		Power.disabled = true
		if counter == 1:
			Power.hint_tooltip = "Ready next turn"
		else:
			Power.hint_tooltip = "Ready in " + str(counter) + " turns"


func enable_power():
	Power.icon = ready_icon
	Power.disabled = false
	Power.hint_tooltip = "Ready!"
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


func _on_Power_pressed():
	activate_power()
	disable_power()


func add_armor(armor):
	gm.add_armor(armor)


func draw_card(card):
	gm.draw_card(card)
