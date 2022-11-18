extends Node


static func get_power_string(power):
	return get_action(power) + " " + get_frequency(power)


static func get_action(power):
	if power.type == "armor":
		return "Add " + str(power.value) + " armor"
	if power.type == "card":
		return "Draw 1 " + str(power.value) + " card"
	else:
		return ""


static func get_frequency(power):
	if power.when.get("frequency"):
		if power.when.frequency == 1:
			return "every turn"
		else:
			return "every " + str(power.when.frequency) + " turns"
	else:
		return ""
