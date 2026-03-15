extends Node

@onready var game_manager: Node = $"../Game_Manager"
@onready var mood_text: Label = $"../User_Interface/Dealer_Interface/Mood_Label"
@onready var affection_text: Label = $"../User_Interface/Dealer_Interface/Affection_Label"

var mood = 100.0:
	set(value):
		mood = clamp(value, 0, 100)
var affection = 30.0:
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
	if mood >= 20 and mood < 50:
		game_manager.mood_level = 1
	if mood >= 50 and mood < 65:
		game_manager.mood_level = 2
	if mood >= 65 and mood < 80:
		game_manager.mood_level = 3
	if mood >= 80 and mood < 90:
		game_manager.mood_level = 4
	if mood >= 90:
		game_manager.mood_level = 5
