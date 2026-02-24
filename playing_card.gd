extends Control

@onready var sprite = $Card/AnimatedSprite2D

func _ready() -> void:
	randomize() #MOVE LATER TO GLOBAL OBJECT
	var max_frames = sprite.sprite_frames.get_frame_count(sprite.animation)
	sprite.frame = randi_range(1, max_frames-1)
