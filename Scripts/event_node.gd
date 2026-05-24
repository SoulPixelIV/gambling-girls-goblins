extends Control

func _on_mouse_entered():
	scale = Vector2(1.4, 1.4)

func _on_mouse_exited():
	scale = Vector2(1, 1)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("node_clicked", self)
