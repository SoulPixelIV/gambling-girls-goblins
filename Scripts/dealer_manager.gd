extends Node

@onready var game_manager: Node = $"../Game_Manager"
@onready var mood_text: Label = $"../User_Interface/Dealer_Interface/Mood_Label"
@onready var affection_text: Label = $"../User_Interface/Dealer_Interface/Affection_Label"

var mood = 30.0
var affection = 30.0

func _ready() -> void:
	_update_dealer_stats()

func _update_dealer_stats():
	mood_text.text = str(int(mood))
	affection_text.text = str(int(affection))
	
	if mood <= 20:
		mood_text.add_theme_color_override("font_color", Color.RED)
	else:
		mood_text.add_theme_color_override("font_color", Color.GREEN_YELLOW)
	if affection <= 20:
		affection_text.add_theme_color_override("font_color", Color.RED)
	else:
		affection_text.add_theme_color_override("font_color", Color.GREEN_YELLOW)
