extends Node

@onready var game_manager: Node = $"../../Game_Manager"
@onready var dealer_manager = $"../../Dealer"
@onready var mood_stat_text: Label = $"Mood_Stat_Label"
@onready var affection_stat_text: Label = $"Affection_Stat_Label"
@onready var status1_text: Label = $"Status1_Label"
@onready var status2_text: Label = $"Status2_Label"
@onready var status3_text: Label = $"Status3_Label"
@onready var status4_text: Label = $"Status4_Label"
@onready var debuff1_text: Label = $"Status1_Debuff_Label"

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
		
	#Update Bonus Stat Texts
	if game_manager.mood_level == 0:
		status1_text.text = ""
		status2_text.text = ""
		status3_text.text = ""
		status4_text.text = ""
		debuff1_text.text = "Landing on 19 is Bust"
	if game_manager.mood_level == 1:
		status1_text.text = ""
		status2_text.text = ""
		status3_text.text = ""
		status4_text.text = ""
		debuff1_text.text = ""
	if game_manager.mood_level == 2:
		status1_text.text = "7 can be changed to 6 or 8"
		status2_text.text = ""
		status3_text.text = ""
		status4_text.text = ""
		debuff1_text.text = ""
	if game_manager.mood_level == 3:
		status1_text.text = "7 can be changed to 6 or 8"
		status2_text.text = "Queen counts as Ace"
		status3_text.text = ""
		status4_text.text = ""
		debuff1_text.text = ""
	if game_manager.mood_level == 4:
		status1_text.text = "7 can be changed to 6 or 8"
		status2_text.text = "Queen counts as Ace"
		status3_text.text = "Player wins on Draw"
		status4_text.text = ""
		debuff1_text.text = ""
	if game_manager.mood_level == 5:
		status1_text.text = "7 can be changed to 6 or 8"
		status2_text.text = "Queen counts as Ace"
		status3_text.text = "Player wins on Draw"
		status4_text.text = "Occasionally redraw last Card on Bust"
		debuff1_text.text = ""
