extends Label


func _ready():
	var _signal = gm.connect("card_count_updated", self, "_on_card_count_updated")
	update_card_count()


func _on_card_count_updated():
	update_card_count()


func update_card_count():
	text = "Draw: " + str(len(gm.current_cards_left)) + "/" + str(len(gm.deck))\
	+ "  -  Hand: " + str(len(gm.in_hand))\
	+ "  -  Discard: " + str(len(gm.current_cards_discarded))
