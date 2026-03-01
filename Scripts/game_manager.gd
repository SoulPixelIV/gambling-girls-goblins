extends Node

@onready var playing_card = preload("res://Prefabs/playing_card.tscn")
@onready var hand = $"../Hand"
@onready var enemy_hand = $"../Enemy_Hand"
@onready var game_manager = $"../Game_Manager"
@onready var player_score_text: Label = $"../User Interface/Player_Score"
@onready var enemy_score_text: Label = $"../User Interface/Enemy_Score"
@onready var final_score_text: Label = $"../User Interface/Final_Score"

@export var enemy: Node

var player_health = 100
var turn_state = -1 #Turnstate -1 -> First Enemy Draw | Turnstate 0 -> Normal Enemy Draw | Turnstate 1 -> Player Draw
var delay_timer = 2
var card_index = 0
var enemy_card_index = 0
var player_score = 0
var enemy_score = 0
var player_out = false
var enemy_out = false
var deck = ["2H", "2D", "2C", "2S", "3H", "3D", "3C", "3S", "4H", "4D", "4C", "4S", 
"5H", "5D", "5C", "5S", "6H", "6D", "6C", "6S", "7H", "7D", "7C", "7S", 
"8H", "8D", "8C", "8S", "9H", "9D", "9C", "9S", "10H", "10D", "10C", "10S", 
"JH", "JD", "JC", "JS", "QH", "QD", "QC", "QS", "KH", "KD", "KC", "KS", 
"AH", "AD", "AC", "AS"]

func _ready() -> void:
	randomize()
	
func _process(delta: float) -> void:
	#Enemys First Draw
	if turn_state == -1:
		spawn_enemy_playing_card(260 + 100 * enemy_card_index, 160)
		enemy_card_index += 1
		turn_state = 1
	
	#Enemys Turn
	if turn_state == 0 && !enemy_out:
		delay_timer -= delta
		if delay_timer < 0:
			spawn_enemy_playing_card(260 + 100 * enemy_card_index, 160)
			enemy_card_index += 1
			turn_state = 1
			delay_timer = 2
			
	#Enemy keeps going when Player is out
	if player_out:
		player_score_text.add_theme_color_override("font_color", Color(1, 0, 0))
		turn_state = 0
		
	#Player keeps going when Enemy is out
	if enemy_out:
		enemy_score_text.add_theme_color_override("font_color", Color(1, 0, 0))
		turn_state = 1
		
	#Damage Calculating Phase
	if player_out && enemy_out:
		delay_timer -= delta
		if delay_timer < 0:
			player_score_text.add_theme_color_override("font_color", Color(1, 1, 1))
			enemy_score_text.add_theme_color_override("font_color", Color(1, 1, 1))
			player_score_text.text = ""
			enemy_score_text.text = ""
			#final_score_text.text = str("Player " + str(player_score) + " vs " + str(enemy_score) + " Enemy")
			#Delete All Playing Cards
			for hand_child in hand.get_children():
				hand_child.queue_free()
			for enemy_hand_child in enemy_hand.get_children():
				enemy_hand_child.queue_free()
		
func _on_hit_button_pressed() -> void:
	#Draw Card
	if turn_state == 1 && !player_out:
		spawn_playing_card(110 + 100 * card_index, 500)
		card_index += 1
		turn_state = 0
		
func _on_stand_button_pressed() -> void:
	if card_index > 0:
		player_out = true
		
func spawn_playing_card(x, y):
	if deck.size() > 0:
		var rand_card_index = randi_range(0, deck.size() - 1) #Select Random Card from Deck
		var card_instance = playing_card.instantiate()
		card_instance.card_played.connect(_on_card_played) #Receive Card Value from Instantiated Card
		card_instance.value = deck[rand_card_index] #Give Created Card Value
		deck.remove_at(rand_card_index) #Remove Card from Deck
		hand.add_child(card_instance)
		card_instance.position = Vector2(x, y)
		
func spawn_enemy_playing_card(x, y):
	if enemy != null:
		if enemy.deck.size() > 0:
			var rand_card_index2 = randi_range(0, enemy.deck.size() - 1) #Select Random Card from Deck
			var enemy_card_instance = playing_card.instantiate()
			enemy_card_instance.card_played.connect(_on_card_played_enemy) #Receive Card Value from Instantiated Card
			enemy_card_instance.value = deck[rand_card_index2] #Give Created Card Value
			enemy.deck.remove_at(rand_card_index2) #Remove Card from Deck
			enemy_hand.add_child(enemy_card_instance)
			enemy_card_instance.position = Vector2(x, y)
			
func _on_card_played(value):
	player_score += value
	player_score_text.text = str(player_score)
	
	#Check if Player is over 21
	if player_score > 21:
		player_out = true
	
func _on_card_played_enemy(value):
	enemy_score += value
	enemy_score_text.text = str(enemy_score)
	
	#Check if Enemy is over 21
	if enemy_score > 21:
		enemy_out = true
