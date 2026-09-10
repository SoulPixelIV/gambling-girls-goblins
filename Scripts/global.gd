extends Node

var player_boring_stat = 0
var player_funny_stat = 0
var player_unlucky_stat = 0
var player_lucky_stat = 0

var holding_card_value = 0
var holding_card_rarity = 0
var holding_card_mutation = 0

var fthedealer_card = "2H"
var fthedealer_card2 = "2H"
var decision_hi_lo_eq = 0 #0 = High ; 1 = low ; 2 = Equal

#Restart Game with "P"
func _input(event):
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()
