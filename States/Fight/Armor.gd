extends Label



func _ready():
	update_armor()
	var _signal = gm.connect("armor_changed", self, "update_armor")


func update_armor():
	self.text = "Armor: " + str(gm.current_armor)
