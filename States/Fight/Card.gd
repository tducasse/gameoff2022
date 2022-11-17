extends MarginContainer

onready var Name = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/Name
onready var Picture = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/PictureContainer/Picture
onready var Cost = $ColorRect/MarginContainer/VBoxContainer/Cost
onready var PictureContainer = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/PictureContainer
onready var Overlay = $Overlay
onready var Text = $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/Text


signal card_clicked

var params = null

func _ready():
	var _signal = gm.connect("mana_changed", self, "change_playable")


func init(config):
	params = config
	Name.text = str(params.name)
	Cost.text = str(params.cost)
	Picture.texture = load("res://Assets/Cards/Images/" + str(params.image))
	var scale = PictureContainer.get_rect().size.x / Picture.texture.get_size().x
	Picture.scale.x = scale
	Picture.scale.y = scale
	Text.text = get_stats_text()



func _on_Overlay_gui_input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		emit_signal("card_clicked")


func change_playable():
	if params.cost > gm.current_mana:
		Overlay.color.a = 0.5
	else:
		Overlay.color.a = 0


func get_stats_text():
	var stats = []
	var s = params.get("self")
	var o = params.get("other")
	var t = params.get("times")
	if s:
		var damage = s.get("damage")
		if damage:
			stats.append("hurt: " + str(damage))
		var armor = s.get("armor")
		if armor:
			stats.append("armor: " + str(armor))
	if o:
		var damage = o.get("damage")
		var armor = o.get("armor")
		var status = o.get("status")
		if damage:
			stats.append("damage: " + str(damage))
		if armor:
			stats.append("foe armor:" + str(armor))
		if status:
			for st in status:
				stats.append(st + ": " + str(status[st]))
	if t:
		stats.append("replay: " + str(t-1))
	return "\n".join(stats)
