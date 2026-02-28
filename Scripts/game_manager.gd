extends Node

@onready var deck = $"../Deck"

var turn_state = 1
var delay_timer = 2
var enemy_card_index = 0

func _ready() -> void:
	randomize()
	
func _process(delta: float) -> void:	
	#Enemys Turn
	if turn_state == 0:
		delay_timer -= delta
		if delay_timer < 0:
			deck.spawn_enemy_playing_card(260 + 100 * enemy_card_index, 160)
			enemy_card_index += 1
			turn_state = 1
			delay_timer = 2
			
	print(delay_timer)
