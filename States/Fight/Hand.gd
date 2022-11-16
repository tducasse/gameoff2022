extends MarginContainer

onready var Slots = $Slots


func _ready():
	var _signal = gm.connect("draw_card", self, "_draw_card")


func add_card(card):
	var slot = Slots.get_free_slot()
	if slot:
		slot.put_card(card)


func _draw_card(name):
	var card = gm.cards[name].duplicate()
	add_card(card)


func discard():
	Slots.discard()


func draw(number):
	gm.reset_hand()
	for _i in range(number):
		add_card(pick_random_card())


func pick_random_card():
	if len(gm.current_cards_left) < 1:
		gm.shuffle()
	var card = gm.current_cards_left[randi() % gm.current_cards_left.size()]
	gm.remove_from_deck(card)
	var copyCard = card.duplicate()
	return copyCard


func new_turn():
	draw(gm.cards_per_turn)
