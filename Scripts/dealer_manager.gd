extends Node

@onready var game_manager: Node = $"../Game_Manager"
@onready var mood_text: Label = $"../User_Interface/Dealer_Interface/Mood_Label"
@onready var affection_text: Label = $"../User_Interface/Dealer_Interface/Affection_Label"

var mood = 35.0:
	set(value):
		mood = clamp(value, 0, 100)
var affection = 35.0:
	set(value):
		affection = clamp(value, 0, 100)

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
		
	if mood < 20:
		game_manager.mood_level = 0
	if mood >= 20 and mood < 45:
		game_manager.mood_level = 1
	if mood >= 45 and mood < 58:
		game_manager.mood_level = 2
	if mood >= 58 and mood < 69:
		game_manager.mood_level = 3
	if mood >= 69 and mood < 80:
		game_manager.mood_level = 4
	if mood >= 80:
		game_manager.mood_level = 5
		
	if affection < 20:
		game_manager.affection_level = 0
	if affection >= 20 and affection < 45:
		game_manager.affection_level = 1
	if affection >= 45 and affection < 58:
		game_manager.affection_level = 2
	if affection >= 58 and affection < 69:
		game_manager.affection_level = 3
	if affection >= 69 and affection < 80:
		game_manager.affection_level = 4
	if affection >= 80:
		game_manager.affection_level = 5
