extends Area2D

@onready var playing_card = preload("res://Prefabs/playing_card.tscn")
@onready var hand = $"../Hand"
@onready var enemy_hand = $"../Enemy_Hand"
@onready var game_manager = $"../Game_Manager"
@onready var player_score_text: Label = $"../User Interface/Player_Score"
@onready var enemy_score_text: Label = $"../User Interface/Enemy_Score"

@export var enemy: Node

var card_index = 0
var player_score = 0
var enemy_score = 0
var deck = ["2H", "2D", "2C", "2S", "3H", "3D", "3C", "3S", "4H", "4D", "4C", "4S", 
"5H", "5D", "5C", "5S", "6H", "6D", "6C", "6S", "7H", "7D", "7C", "7S", 
"8H", "8D", "8C", "8S", "9H", "9D", "9C", "9S", "10H", "10D", "10C", "10S", 
"JH", "JD", "JC", "JS", "QH", "QD", "QC", "QS", "KH", "KD", "KC", "KS", 
"AH", "AD", "AC", "AS"]

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#Draw Card
	if event is InputEventMouseButton and event.is_pressed():
		if game_manager.turn_state == 1:
			spawn_playing_card(110 + 100 * card_index, 500)
			card_index += 1
			game_manager.turn_state = 0
		
	#Hover Card
	scale.x = 1.2
	scale.y = 1.2
	
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
	
func _on_card_played_enemy(value):
	enemy_score += value
	enemy_score_text.text = str(enemy_score)

func _on_mouse_exited() -> void:
	scale.x = 1
	scale.y = 1
