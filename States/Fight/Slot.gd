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
		card.queue_free()
		card = null


func play_card():
	remove_card()


func _on_card_clicked():
	play_card()

