extends Node2D

@onready var label = $Label

var mutation = 0
var rarity = 0

var lifetime = 4

func _ready() -> void:
	### Charming ###
	if mutation == 1:
		if rarity == 0:
			label.text = "+1 Affection"
			label.add_theme_color_override("font_color", Color.HOT_PINK)
		if rarity == 1:
			label.text = "+3 Affection"
			label.add_theme_color_override("font_color", Color.HOT_PINK)
		if rarity == 2:
			label.text = "+6 Affection"
			label.add_theme_color_override("font_color", Color.HOT_PINK)
	### Playful ###
	if mutation == 2:
		if rarity == 0:
			label.text = "+1 Mood"
			label.add_theme_color_override("font_color", Color.BLUE)
		if rarity == 1:
			label.text = "+3 Mood"
			label.add_theme_color_override("font_color", Color.BLUE)
		if rarity == 2:
			label.text = "+6 Mood"
			label.add_theme_color_override("font_color", Color.BLUE)
	### Rough ###
	if mutation == 3:
		if rarity == 0:
			label.text = "2 Damage | 2 Self Damage"
			label.add_theme_color_override("font_color", Color.ORANGE)
		if rarity == 1:
			label.text = "4 Damage | 1 Self Damage"
			label.add_theme_color_override("font_color", Color.ORANGE)
		if rarity == 2:
			label.text = "6 Damage"
			label.add_theme_color_override("font_color", Color.ORANGE)
	### Lovely ###
	if mutation == 4:
		if rarity == 0:
			label.text = "+1 Health"
			label.add_theme_color_override("font_color", Color.INDIAN_RED)
		if rarity == 1:
			label.text = "+3 Health"
			label.add_theme_color_override("font_color", Color.INDIAN_RED)
		if rarity == 2:
			label.text = "+5 Health"
			label.add_theme_color_override("font_color", Color.INDIAN_RED)
			
func _process(delta: float) -> void:
	lifetime -= delta
	
	if lifetime > 0:
		position.y -= delta * 14
	else:
		queue_free()
