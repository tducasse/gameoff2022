extends Label



func _ready():
	update_armor(false)
	var _signal = gm.connect("armor_changed", self, "update_armor")


func update_armor(b=true):
	self.text = "Armor: " + str(gm.current_armor)
	if b:
		gm.blink(self)
