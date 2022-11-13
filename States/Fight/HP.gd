extends Label



func _ready():
	update_hp()
	var _signal = gm.connect("hp_changed", self, "update_hp")


func update_hp():
	self.text = "HP: " + str(gm.current_hp)
