extends Node

@onready var dialog: Label = $"../User_Interface/Dialog_Label"
@onready var answer1_parent = $"../User_Interface/Answer1_Button_Parent"
@onready var answer2_parent = $"../User_Interface/Answer2_Button_Parent"
@onready var answer3_parent = $"../User_Interface/Answer3_Button_Parent"
@onready var answer4_parent = $"../User_Interface/Answer4_Button_Parent"
@onready var answer1_button = $"../User_Interface/Answer1_Button_Parent/Answer1_Button"
@onready var answer2_button = $"../User_Interface/Answer2_Button_Parent/Answer2_Button"
@onready var answer3_button = $"../User_Interface/Answer3_Button_Parent/Answer3_Button"
@onready var answer4_button = $"../User_Interface/Answer4_Button_Parent/Answer4_Button"
@onready var hit_button = $"../User_Interface/Hit_Button"
@onready var stand_button = $"../User_Interface/Stand_Button"

var dialog_mode = 0

func _ready() -> void:
	_check_dialog_mode()
	#Dialog -> "I've got this. Let's Play." "With your smile..I feel unstoppable." "You won't keep up."
	
func _check_dialog_mode() -> void:
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

	if dialog_mode == 1:
		answer1_parent.hide()
		answer2_parent.hide()
		answer3_parent.hide()
		answer4_parent.hide()
		hit_button.show()
		stand_button.show()

func _on_answer_1_button_pressed() -> void:
	dialog_mode = 1
	_check_dialog_mode()

func _on_answer_2_button_pressed() -> void:
	dialog_mode = 1
	_check_dialog_mode()

func _on_answer_3_button_pressed() -> void:
	dialog_mode = 1
	_check_dialog_mode()

func _on_answer_4_button_pressed() -> void:
	dialog_mode = 1
	_check_dialog_mode()
