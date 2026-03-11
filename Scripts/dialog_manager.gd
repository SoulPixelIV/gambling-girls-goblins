extends Node

@onready var dialog: Label = $"../User_Interface/Dialog_Label"
@onready var answer1_button = $"../User_Interface/Answer1_Button"
@onready var answer2_button = $"../User_Interface/Answer2_Button"
@onready var answer3_button = $"../User_Interface/Answer3_Button"
@onready var answer4_button = $"../User_Interface/Answer4_Button"

var dialog_mode = 0

func _ready() -> void:
	if dialog_mode == 0:
		dialog.text = "Well, shall we begin..?"
		
		answer1_button.modulate = Color.GREEN_YELLOW
		answer1_button.text = "Hit me."
		answer1_button.tooltip_text = "[LOSE] -1 Mood | [WIN] +1 Mood"
		
		answer2_button.modulate = Color.YELLOW
		answer2_button.text = "Confident"
		answer2_button.tooltip_text = "[LOSE] -2 Mood | [WIN] +2 Mood"
		
		answer3_button.modulate = Color.BLUE_VIOLET
		answer3_button.text = "Flirty"
		answer3_button.tooltip_text = "[LOSE] -3 Affection -1 Mood | [Win] +4 Affection"

		answer4_button.modulate = Color.ORANGE_RED
		answer4_button.text = "Cocky"
		answer4_button.tooltip_text = "[LOSE] -1 Affection -3 Mood | [WIN] +2 Affection +1 Mood"

	#Dialog -> "I've got this. Let's Play." "With your smile..I feel unstoppable." "You won't keep up."
