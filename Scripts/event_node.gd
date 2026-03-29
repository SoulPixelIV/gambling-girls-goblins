extends Control

func _on_mouse_entered():
	scale = Vector2(1.4, 1.4)

func _on_mouse_exited():
	scale = Vector2(1, 1)
