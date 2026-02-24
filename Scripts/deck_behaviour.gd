extends Area2D

@onready var playing_card = preload("res://Prefabs/playing_card.tscn")
@onready var hand = $"../Hand"

var card_index = 0

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#Draw Card
	if event is InputEventMouseButton and event.is_pressed():
		spawn_playing_card(110 + 100 * card_index, 500)
		card_index += 1
		print("Spawned Card")
		
	#Hover Card
	scale.x = 1.2
	scale.y = 1.2
	
func spawn_playing_card(x, y):
	var card_instance = playing_card.instantiate()
	hand.add_child(card_instance)
	card_instance.position = Vector2(x, y)

func _on_mouse_exited() -> void:
	scale.x = 1
	scale.y = 1
