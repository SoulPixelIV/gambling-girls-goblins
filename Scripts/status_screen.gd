extends Node

@onready var game_manager: Node = $"../../Game_Manager"
@onready var mood_stat_text: Label = $"Mood_Stat_Label"
@onready var affection_stat_text: Label = $"Affection_Stat_Label"

func _ready() -> void:
	_update_betting_status()

func _update_betting_status():
	if game_manager.pot_mood == -1:
		mood_stat_text.text = ""
	else:
		mood_stat_text.text = str(game_manager.pot_mood)
	if game_manager.pot_affection == -1:
		affection_stat_text.text = ""
	else:
		affection_stat_text.text = str(game_manager.pot_affection)
