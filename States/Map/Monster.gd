extends MarginContainer


signal monster_clicked


func _on_Overlay_gui_input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		emit_signal("monster_clicked")
