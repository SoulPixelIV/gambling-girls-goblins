extends Node2D

var mutation = 0
var rarity = 0

var lifetime = 4

func _ready() -> void:
	### Charming ###
	if mutation == 1:
		if rarity == 0:
			$Label.text = "+1 Affection"
			$Label.add_theme_color_override("font_color", Color.HOT_PINK)
		if rarity == 1:
			$Label.text = "+3 Affection"
			$Label.add_theme_color_override("font_color", Color.HOT_PINK)
		if rarity == 2:
			$Label.text = "+6 Affection"
			$Label.add_theme_color_override("font_color", Color.HOT_PINK)
	### Playful ###
	if mutation == 2:
		if rarity == 0:
			$Label.text = "+1 Mood"
			$Label.add_theme_color_override("font_color", Color.BLUE)
		if rarity == 1:
			$Label.text = "+3 Mood"
			$Label.add_theme_color_override("font_color", Color.BLUE)
		if rarity == 2:
			$Label.text = "+6 Mood"
			$Label.add_theme_color_override("font_color", Color.BLUE)
	### Rough ###
	if mutation == 3:
		if rarity == 0:
			$Label.text = "2 Damage | 2 Self Damage"
			$Label.add_theme_color_override("font_color", Color.ORANGE)
		if rarity == 1:
			$Label.text = "4 Damage | 1 Self Damage"
			$Label.add_theme_color_override("font_color", Color.ORANGE)
		if rarity == 2:
			$Label.text = "6 Damage"
			$Label.add_theme_color_override("font_color", Color.ORANGE)
	### Lovely ###
	if mutation == 4:
		if rarity == 0:
			$Label.text = "+1 Health"
			$Label.add_theme_color_override("font_color", Color.INDIAN_RED)
		if rarity == 1:
			$Label.text = "+3 Health"
			$Label.add_theme_color_override("font_color", Color.INDIAN_RED)
		if rarity == 2:
			$Label.text = "+5 Health"
			$Label.add_theme_color_override("font_color", Color.INDIAN_RED)
			
func _process(delta: float) -> void:
	lifetime -= delta
	
	if lifetime > 0:
		position.y -= delta * 14
	else:
		queue_free()
