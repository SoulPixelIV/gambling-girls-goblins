extends Area2D

@onready var sprite = $Sprite2D

func _on_mouse_entered():
	sprite.scale = Vector2(1.2, 1.2) # größer

func _on_mouse_exited():
	sprite.scale = Vector2(1, 1) # normal
