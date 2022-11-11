extends MarginContainer
class_name Hand

onready var Slots = $Slots
onready var Card = preload("res://Common/Card/Card.tscn")


var slots = []


func _ready():
	var children = Slots.get_children()
	for index in len(children):
		var slot = children[index]
		slots.append(slot)


func add_card(card_params):
	var card = Card.instance()
	for i in len(slots):
		var slot = slots[i]
		if slot.get_child_count() == 0:
			slot.add_child(card)
			card.init(card_params)
			return


func discard():
	for i in len(slots):
		var slot = slots[i]
		for child in slot.get_children():
			slot.remove_child(child)


func draw(number):
	for _i in range(number):
		add_card(pick_random_card())


func pick_random_card():
	if len(gm.cards) < 1:
		return
	var card = gm.cards[randi() % gm.cards.size()]
	var copyCard = card.duplicate()
	return copyCard


func new_turn():
	draw(gm.cards_per_turn)
