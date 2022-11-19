extends Label



func _ready():
	update_hp(false)
	var _signal = gm.connect("hp_changed", self, "update_hp")


func update_hp(b=true):
	self.text = "HP: " + str(gm.current_hp)
	if b:
		gm.blink(self)
