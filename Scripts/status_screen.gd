extends Node

@onready var game_manager: Node = $"../../Game_Manager"
@onready var dealer_manager = $"../../Dealer"
@onready var mood_stat_text: Label = $"Mood_Stat_Label"
@onready var affection_stat_text: Label = $"Affection_Stat_Label"
@onready var status1_text: Label = $"Status1_Label"
@onready var status2_text: Label = $"Status2_Label"
@onready var status3_text: Label = $"Status3_Label"
@onready var status4_text: Label = $"Status4_Label"
@onready var status5_text: Label = $"Status5_Label"
@onready var status6_text: Label = $"Status6_Label"
@onready var status7_text: Label = $"Status7_Label"
@onready var status8_text: Label = $"Status8_Label"
@onready var debuff1_text: Label = $"Status1_Debuff_Label"
@onready var debuff2_text: Label = $"Status2_Debuff_Label"
@onready var player_healthbar: Label = $"Pot_Text"
@onready var enemy_healthbar: Label = $"Pot_Text2"

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
	#############################     MOOD        #######################################################
	if game_manager.mood_level == 0:
		status1_text.text = ""
		status2_text.text = ""
		status3_text.text = ""
		status4_text.text = ""
		debuff1_text.text = "Enemy always Crits"
	if game_manager.mood_level == 1:
		status1_text.text = ""
		status2_text.text = ""
		status3_text.text = ""
		status4_text.text = ""
		debuff1_text.text = ""
	if game_manager.mood_level == 2:
		status1_text.text = "Boosts Player Attack"
		status2_text.text = ""
		status3_text.text = ""
		status4_text.text = ""
		debuff1_text.text = ""
	if game_manager.mood_level == 3:
		status1_text.text = "Boosts Player Attack"
		status2_text.text = "Reduces Enemy Damage"
		status3_text.text = ""
		status4_text.text = ""
		debuff1_text.text = ""
	if game_manager.mood_level == 4:
		status1_text.text = "Boosts Player Attack"
		status2_text.text = "Reduces Enemy Damage"
		status3_text.text = "No more Self Damage"
		status4_text.text = ""
		debuff1_text.text = ""
	if game_manager.mood_level == 5:
		status1_text.text = "Boosts Player Attack"
		status2_text.text = "Reduces Enemy Damage"
		status3_text.text = "No more Self Damage"
		status4_text.text = "Occasionally shield from Attack"
		debuff1_text.text = ""
		
	#############################     Affection        #######################################################
	if game_manager.affection_level == 0:
		status5_text.text = ""
		status6_text.text = ""
		status7_text.text = ""
		status8_text.text = ""
		debuff2_text.text = "Landing on 19 is Bust"
	if game_manager.affection_level == 1:
		status5_text.text = ""
		status6_text.text = ""
		status7_text.text = ""
		status8_text.text = ""
		debuff2_text.text = ""
	if game_manager.affection_level == 2:
		status5_text.text = "7 can be changed to 6 or 8"
		status6_text.text = ""
		status7_text.text = ""
		status8_text.text = ""
		debuff2_text.text = ""
	if game_manager.affection_level == 3:
		status5_text.text = "7 can be changed to 6 or 8"
		status6_text.text = "Queen counts as Ace"
		status7_text.text = ""
		status8_text.text = ""
		debuff2_text.text = ""
	if game_manager.affection_level == 4:
		status5_text.text = "7 can be changed to 6 or 8"
		status6_text.text = "Queen counts as Ace"
		status7_text.text = "Player deals 5 Damage on Draw"
		status8_text.text = ""
		debuff2_text.text = ""
	if game_manager.affection_level == 5:
		status5_text.text = "7 can be changed to 6 or 8"
		status6_text.text = "Queen counts as Ace"
		status7_text.text = "Player deals 5 Damage on Draw"
		status8_text.text = "Occasionally redraw on Bust"
		debuff2_text.text = ""
	
