extends MarginContainer

onready var Card = preload("res://States/Fight/Card.tscn")

var card = null


func is_empty():
	return card == null


func put_card(card_params):
	card = Card.instance()
	add_child(card)
	card.init(card_params)
	var _signal = card.connect("card_clicked", self, "_on_card_clicked")


func remove_card():
	if card:
		gm.discard(card.params)
		card.queue_free()
		card = null


func play_card():
	gm.spend_mana(card.params.cost)
	gm.emit_signal("card_played", card.params)
	remove_card()


func _on_card_clicked():
	if gm.has_enough_mana(card.params.cost):
		play_card()
	else:
		print("not enough mana")
