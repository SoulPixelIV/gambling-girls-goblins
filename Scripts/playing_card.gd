extends Control

@onready var border_playing_card = preload("res://Prefabs/card_border.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var mutation_label = $Label
var mat
var card_border = null

signal card_played(value)

var game_manager = null
var value = 0
var score = 0
var rarity = 0
var mutation = 0
var frame_index = 0
var player_card = true
var hovered = false
var rarity_text = ""
var mutation_text = ""

var card_anim_index = 0

var is_booster_card = false
var is_selected_card = false
var is_inventory_card = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	
	sprite.material = sprite.material.duplicate()
	mat = sprite.material as ShaderMaterial
	
	if !is_selected_card:
		scale.x = 0
		scale.y = 0
		
	if is_inventory_card:
		scale.x = 0.225
		scale.y = 0.225
		
	#Create Card Border if selectable Card
	if is_inventory_card:
		if get_card_rank(str(value)) == get_card_rank(str(Global.holding_card_value)):
			card_border = border_playing_card.instantiate()
			add_child(card_border)
			card_border.z_index = 999
			scale.x = 0.25
			scale.y = 0.25
			z_index = 998
			
	#Copy Global Variables
	if is_selected_card:
		value = Global.holding_card_value
		rarity = Global.holding_card_rarity
		mutation = Global.holding_card_mutation
	
	#Set Card Frame
	set_card_value()
	
	if player_card:
		emit_signal("card_played", score, value) #Send card value out
	else:
		emit_signal("card_played_enemy", score, value) #Send card value out
	
func _process(delta: float) -> void:
	#Rarity Effects
	if rarity == 0:
		mat.set_shader_parameter("rarity_strength", 0.0)
		get_node("CPUParticles2D").emitting = false
		get_node("CPUParticles2D2").emitting = false
		rarity_text = ""
	elif rarity == 1:
		mat.set_shader_parameter("rarity_strength", 1.1)
		get_node("CPUParticles2D").emitting = false
		get_node("CPUParticles2D2").emitting = false
		rarity_text = "Rare"
	elif rarity == 2:
		mat.set_shader_parameter("rarity_strength", 2.0)
		rarity_text = "Ultra Rare"
		
	#Mutation Effects
	#Charming
	if mutation == 1:
		sprite.modulate = Color.BLUE
		mutation_text = "Charming"
	#Playful
	elif mutation == 2:
		sprite.modulate = Color.GREEN
		mutation_text = "Playful"
	#Rough
	elif mutation == 3:
		sprite.modulate = Color.SANDY_BROWN
		mutation_text = "Rough"
	#Lovely
	elif mutation == 4:
		sprite.modulate = Color.DEEP_PINK
		mutation_text = "Lovely"
		
	#Update Card Text
	mutation_label.text = rarity_text + " " + mutation_text
		
	#Update Card Border if not Needed anymore
	if game_manager && game_manager.game_mode == 6:
		if card_border:
			card_border.queue_free()
			
		if is_selected_card:
			queue_free()
		
	if !is_selected_card and !is_inventory_card:
		if is_booster_card:
			if card_anim_index == 0:
				if scale.x < 0.85:
					scale.x += delta * 2
					scale.y += delta * 2
				else:
					card_anim_index = 1
					
			if card_anim_index == 1:
				if scale.x > 0.75:
					scale.x -= delta * 2.5
					scale.y -= delta * 2.5
				else:
					card_anim_index = 2
					
			if card_anim_index == 2:
				if !hovered:
					scale.x = 0.75
					scale.y = 0.75
				else:
					scale.x = 0.85
					scale.y = 0.85
		else:
			if card_anim_index == 0:
				if scale.x < 0.3:
					scale.x += delta * 2
					scale.y += delta * 2
				else:
					card_anim_index = 1
					
			if card_anim_index == 1:
				if scale.x > 0.252:
					scale.x -= delta * 2.5
					scale.y -= delta * 2.5
				else:
					card_anim_index = 2
					
			if card_anim_index == 2:
					scale.x = 0.25
					scale.y = 0.25
					
	if is_inventory_card:
		if hovered:
			scale.x = 0.3
			scale.y = 0.3
		else:
			scale.x = 0.25
			scale.y = 0.25
		
func _on_mouse_entered() -> void:
	if game_manager && (game_manager.game_mode == 4 || game_manager.game_mode == 5):
		if is_booster_card:
			hovered = true
			
		if is_inventory_card and get_card_rank(str(value)) == get_card_rank(str(Global.holding_card_value)):
			hovered = true

func _on_mouse_exited() -> void:
	if is_booster_card:
		hovered = false
		
	if is_inventory_card and get_card_rank(str(value)) == get_card_rank(str(Global.holding_card_value)):
		hovered = false
		
func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			##### SELECTING 1 OF 3 BOOSTER CARDS #####
			if is_booster_card:
				Global.holding_card_value = value
				Global.holding_card_rarity = rarity
				Global.holding_card_mutation = mutation
				
				game_manager._switch_game_mode(5)
				
			##### REPLACING CARD IN INVENTORY #####
			if game_manager && (game_manager.game_mode == 4 || game_manager.game_mode == 5):
				if is_inventory_card and get_card_rank(str(value)) == get_card_rank(str(Global.holding_card_value)):
					value = Global.holding_card_value
					rarity = Global.holding_card_rarity
					mutation = Global.holding_card_mutation
					set_card_value()
					
					game_manager._switch_game_mode(6)
				
func get_card_rank(card: String) -> String:
	return card.left(card.length() - 1)

func set_card_value():
	match value:
		"2H":
			frame_index = 1
			score = 2
		"2D":
			frame_index = 2
			score = 2
		"2C":
			frame_index = 3
			score = 2
		"2S":
			frame_index = 4
			score = 2
		"3H":
			frame_index = 5
			score = 3
		"3D":
			frame_index = 6
			score = 3
		"3C":
			frame_index = 7
			score = 3
		"3S":
			frame_index = 8
			score = 3
		"4H":
			frame_index = 9
			score = 4
		"4D":
			frame_index = 10
			score = 4
		"4C":
			frame_index = 11
			score = 4
		"4S":
			frame_index = 12
			score = 4
		"5H":
			frame_index = 13
			score = 5
		"5D":
			frame_index = 14
			score = 5
		"5C":
			frame_index = 15
			score = 5
		"5S":
			frame_index = 16
			score = 5
		"6H":
			frame_index = 17
			score = 6
		"6D":
			frame_index = 18
			score = 6
		"6C":
			frame_index = 19
			score = 6
		"6S":
			frame_index = 20
			score = 6
		"7H":
			frame_index = 21
			score = 7
		"7D":
			frame_index = 22
			score = 7
		"7C":
			frame_index = 23
			score = 7
		"7S":
			frame_index = 24
			score = 7
		"8H":
			frame_index = 25
			score = 8
		"8D":
			frame_index = 26
			score = 8
		"8C":
			frame_index = 27
			score = 8
		"8S":
			frame_index = 28
			score = 8
		"9H":
			frame_index = 29
			score = 9
		"9D":
			frame_index = 30
			score = 9
		"9C":
			frame_index = 31
			score = 9
		"9S":
			frame_index = 32
			score = 9
		"10H":
			frame_index = 33
			score = 10
		"10D":
			frame_index = 34
			score = 10
		"10C":
			frame_index = 35
			score = 10
		"10S":
			frame_index = 36
			score = 10
		"JH":
			frame_index = 37
			score = 10
		"JD":
			frame_index = 38
			score = 10
		"JC":
			frame_index = 39
			score = 10
		"JS":
			frame_index = 40
			score = 10
		"QH":
			frame_index = 41
			score = 10
		"QD":
			frame_index = 42
			score = 10
		"QC":
			frame_index = 43
			score = 10
		"QS":
			frame_index = 44
			score = 10
		"KH":
			frame_index = 45
			score = 10
		"KD":
			frame_index = 46
			score = 10
		"KC":
			frame_index = 47
			score = 10
		"KS":
			frame_index = 48
			score = 10
		"AH":
			frame_index = 49
			score = 0
		"AD":
			frame_index = 50
			score = 0
		"AC":
			frame_index = 51
			score = 0
		"AS":
			frame_index = 52
			score = 0
	sprite.frame = frame_index
