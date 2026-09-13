extends Node

@onready var sentence_label = $"User_Interface/Sentence_Label"

@onready var layer_label = $"User_Interface/Layer_Label"
@onready var enemies_label = $"User_Interface/Enemies_Label"
@onready var damage_label = $"User_Interface/Damage_Label"
@onready var score_label = $"User_Interface/Score_Label"

func _ready() -> void:
	layer_label.text = str(Global.layer_count)
	enemies_label.text = str(Global.enemy_count)
	damage_label.text = str(Global.damage_count)
	score_label.text = str((Global.layer_count * 100) + (Global.enemy_count * 25) + (Global.damage_count))
	
	if Global.player_boring_stat <= 3 \
	and Global.player_funny_stat <= 3 \
	and Global.player_unlucky_stat <= 3 \
	and Global.player_lucky_stat <= 3:
		sentence_label.text = "You are an average player"
		return
	
	var highest_stat = max(
			Global.player_boring_stat,
			Global.player_funny_stat,
			Global.player_unlucky_stat,
			Global.player_lucky_stat
		)
		
	if highest_stat == Global.player_lucky_stat:
		sentence_label.text = "You are a lucky player"
	elif highest_stat == Global.player_unlucky_stat:
		sentence_label.text = "You are an unlucky player"
	elif highest_stat == Global.player_funny_stat:
		sentence_label.text = "You are a bold player"
	else:
		sentence_label.text = "You are a safe player"
