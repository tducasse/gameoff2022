extends HBoxContainer


var slots = []


func _ready():
	slots = get_children()


func discard(): 
	for i in len(slots):
		var slot = slots[i]
		slot.remove_card()


func get_free_slot():
	for i in len(slots):
		var slot = slots[i]
		if slot.is_empty():
			return slot
