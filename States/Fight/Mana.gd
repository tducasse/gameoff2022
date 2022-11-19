extends Label



func _ready():
	update_mana(false)
	var _signal = gm.connect("mana_changed", self, "update_mana")


func update_mana(b=true):
	self.text = "Mana: " + str(gm.current_mana)
	if b:
		gm.blink(self)
