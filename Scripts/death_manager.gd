extends Node

func _on_restart_button_pressed() -> void:
	Global.player_boring_stat = 0
	Global.player_funny_stat = 0
	Global.player_unlucky_stat = 0
	Global.player_lucky_stat = 0
	
	Global.layer_count = 1
	Global.enemy_count = 0
	Global.damage_count = 0
	Global.score_count = 0
	
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
