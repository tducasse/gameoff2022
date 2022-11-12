extends Label



func _ready():
	update_mana()
	var _signal = gm.connect("mana_changed", self, "update_mana")


func update_mana():
	self.text = "Mana: " + str(gm.current_mana)
