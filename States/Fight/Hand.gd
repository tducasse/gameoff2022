extends MarginContainer

onready var Slots = $Slots


func add_card(card):
	var slot = Slots.get_free_slot()
	slot.put_card(card)


func discard():
	Slots.discard()


func draw(number):
	for _i in range(number):
		add_card(pick_random_card())


func pick_random_card():
	if len(gm.deck) < 1:
		return
	var card = gm.deck[randi() % gm.deck.size()]
	var copyCard = card.duplicate()
	return copyCard


func new_turn():
	draw(gm.cards_per_turn)
