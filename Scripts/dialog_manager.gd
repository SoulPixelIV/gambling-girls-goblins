extends Node

@onready var game_manager: Node = $"../Game_Manager"
@onready var status_screen: Node = $"../User_Interface/Status_Screen"
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
@onready var tripple_button1 = $"../User_Interface/Tripple_Button1"
@onready var tripple_button2 = $"../User_Interface/Tripple_Button2"
@onready var tripple_button3 = $"../User_Interface/Tripple_Button3"

var dialog_mode = 0

func _ready() -> void:
	_check_dialog_mode()
	#Dialog -> "I've got this. Let's Play." "With your smile..I feel unstoppable." "You won't keep up."
	
func _check_dialog_mode() -> void:
	if dialog_mode == 0:
		answer1_parent.show()
		answer2_parent.show()
		answer3_parent.show()
		answer4_parent.show()
		hit_button.hide()
		stand_button.hide()
		tripple_button1.hide()
		tripple_button2.hide()
		tripple_button3.hide()
		
		dialog.text = "Well, shall we begin..?"
		
		answer1_button.modulate = Color.GREEN_YELLOW
		answer1_button.text = "Hit me."
		answer1_button.tooltip_text = "[LOSE] -8 Mood | [WIN] +8 Mood"
		
		answer2_button.modulate = Color.YELLOW
		answer2_button.text = "Confident"
		answer2_button.tooltip_text = "[LOSE] -14 Mood | [WIN] +14 Mood"
		
		answer3_button.modulate = Color.BLUE_VIOLET
		answer3_button.text = "Flirty"
		answer3_button.tooltip_text = "[LOSE] -3 Affection | [Win] +3 Affection"

		answer4_button.modulate = Color.ORANGE_RED
		answer4_button.text = "Cocky"
		answer4_button.tooltip_text = "[LOSE] -6 Affection -3 Mood | [WIN] +6 Affection +3 Mood"

	if dialog_mode == 1:
		answer1_parent.hide()
		answer2_parent.hide()
		answer3_parent.hide()
		answer4_parent.hide()
		tripple_button1.hide()
		tripple_button2.hide()
		tripple_button3.hide()
		hit_button.show()
		stand_button.show()
		game_manager.begin_fight = true
		status_screen._update_betting_status()
		
	if dialog_mode == 2:
		answer1_parent.hide()
		answer2_parent.hide()
		answer3_parent.hide()
		answer4_parent.hide()
		hit_button.hide()
		stand_button.hide()
		tripple_button1.show()
		tripple_button2.show()
		tripple_button3.show()
		game_manager.begin_fight = true
		status_screen._update_betting_status()

func _on_answer_1_button_pressed() -> void:
	dialog_mode = 1
	game_manager.pot_mood = 8
	game_manager.pot_affection = -1
	_check_dialog_mode()

func _on_answer_2_button_pressed() -> void:
	dialog_mode = 1
	game_manager.pot_mood = 14
	game_manager.pot_affection = -1
	_check_dialog_mode()

func _on_answer_3_button_pressed() -> void:
	dialog_mode = 1
	game_manager.pot_mood = -1
	game_manager.pot_affection = 3
	_check_dialog_mode()

func _on_answer_4_button_pressed() -> void:
	dialog_mode = 1
	game_manager.pot_mood = 3
	game_manager.pot_affection = 6
	_check_dialog_mode()
