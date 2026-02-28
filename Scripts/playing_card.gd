extends Control

@onready var sprite = $Card/AnimatedSprite2D

signal card_played(value)

var value = 0
var score = 0
var frame_index = 0

var card_anim_index = 0

func _ready() -> void:
	scale.x = 0
	scale.y = 0
	randomize() #MOVE LATER TO GLOBAL OBJECT
	
	#Set Card Frame
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
			score = 11
		"AD":
			frame_index = 50
			score = 11
		"AC":
			frame_index = 51
			score = 11
		"AS":
			frame_index = 52
			score = 11
	sprite.frame = frame_index
	emit_signal("card_played", score) #Send card value out
	print(str(value))
	
func _process(delta: float) -> void:
	if card_anim_index == 0:
		if scale.x < 1.1:
			scale.x += delta * 2
			scale.y += delta * 2
		else:
			card_anim_index = 1
			
	if card_anim_index == 1:
		if scale.x > 1.02:
			scale.x -= delta * 2.5
			scale.y -= delta * 2.5
		else:
			card_anim_index = 2
			
	if card_anim_index == 2:
		scale.x = 1
		scale.y = 1
