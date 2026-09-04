extends Node

@onready var game_manager = get_parent().get_node("Game_Manager")

@onready var damage_player_label: RichTextLabel = $"Damage_Player_Label"
@onready var multiplier_player_label: RichTextLabel = $"Multiplier_Player_Label"

var curr_player_damage = 0

func _process(delta: float) -> void:
	#Damage Label
	if game_manager.enemy_score < 22:
		curr_player_damage = max(game_manager.player_score - game_manager.enemy_score, 0)
			
		if curr_player_damage >= 12 and curr_player_damage < 22:
			damage_player_label.text = "[color=orange]" + str(curr_player_damage) + "[/color]"
		elif curr_player_damage >= 5:
			damage_player_label.text = "[color=yellow]" + str(curr_player_damage) + "[/color]"
		else:
			damage_player_label.text = str(curr_player_damage)
			
		if game_manager.player_score > 21:
			damage_player_label.text = "0"
	else:
		damage_player_label.text = "[color=orange]" + str(game_manager.player_score) + "[/color]"
		
	#Multiplier Label
	var multiplier = game_manager.calculate_player_damage_multiplier()
	multiplier_player_label.text = "x" + str(multiplier)
