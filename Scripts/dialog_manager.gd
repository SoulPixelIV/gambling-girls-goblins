extends Node

@onready var game_manager: Node = $"../Game_Manager"
@onready var status_screen: Node = $"../User_Interface/Status_Screen"
@onready var dialog: Label = $"../User_Interface/Dialog_Label"
@onready var dialog_user: Label = $"../User_Interface/Dialog_Label2"
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
@onready var double_button = $"../User_Interface/Double_Button"
@onready var safe_button = $"../User_Interface/Safe_Button"
@onready var tripple_button1 = $"../User_Interface/Tripple_Button1"
@onready var tripple_button2 = $"../User_Interface/Tripple_Button2"
@onready var tripple_button3 = $"../User_Interface/Tripple_Button3"

var dialog_mode = 0

func _ready() -> void:
	_check_dialog_mode()
	
func _check_dialog_mode() -> void:
	if dialog_mode == 0:
		answer1_parent.show()
		answer2_parent.show()
		answer3_parent.show()
		answer4_parent.show()
		hit_button.hide()
		stand_button.hide()
		double_button.hide()
		safe_button.hide()
		tripple_button1.hide()
		tripple_button2.hide()
		tripple_button3.hide()
		
		dialog.text = _random_intro_line()
		
		answer1_button.modulate = Color.GREEN_YELLOW
		answer1_button.text = "Neutral"
		answer1_button.tooltip_text = "[LOSE] -5 Mood | [WIN] +5 Mood"
		
		answer2_button.modulate = Color.YELLOW
		answer2_button.text = "Confident"
		answer2_button.tooltip_text = "[LOSE] -11 Mood | [WIN] +11 Mood"
		
		answer3_button.modulate = Color.BLUE_VIOLET
		answer3_button.text = "Flirty"
		answer3_button.tooltip_text = "[LOSE] -6 Affection | [Win] +6 Affection"

		answer4_button.modulate = Color.ORANGE_RED
		answer4_button.text = "Cocky"
		answer4_button.tooltip_text = "[LOSE] -9 Affection -4 Mood | [WIN] +9 Affection +4 Mood"
		
		dialog_user.text = ""

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
		double_button.show()
		safe_button.show()
		game_manager.begin_fight = true
		status_screen._update_betting_status()
		
		hit_button.tooltip_text = "Draw a Card"
		stand_button.tooltip_text = "Stand on your current Cards (You need atleast 1 Card)"
		double_button.tooltip_text = "Double your Bet (You only draw 1 more Card)"
		safe_button.tooltip_text = "Half your Bet (You cannot double your Bet after that)"
		
	if dialog_mode == 2:
		answer1_parent.hide()
		answer2_parent.hide()
		answer3_parent.hide()
		answer4_parent.hide()
		hit_button.hide()
		stand_button.hide()
		double_button.hide()
		safe_button.hide()
		tripple_button1.show()
		tripple_button2.show()
		tripple_button3.show()
		game_manager.begin_fight = true
		status_screen._update_betting_status()
		
	#Overworld Mode
	if dialog_mode == 3:
		answer1_parent.hide()
		answer2_parent.hide()
		answer3_parent.hide()
		answer4_parent.hide()
		hit_button.hide()
		stand_button.hide()
		double_button.hide()
		safe_button.hide()
		tripple_button1.hide()
		tripple_button2.hide()
		tripple_button3.hide()
		status_screen._update_betting_status()

#################### DEALER DIALOG ########################
func _random_intro_line() -> String:
	var lines = [
		"Well, shall we begin..?",
		"Let's see what luck has in store.",
		"Time to play..",
		"The table is open.",
		"Feeling lucky tonight?",
		"I hope you know what you're doing..",
		"Try not to lose too quickly.",
		"Don't worry..I'll be gentle.",
		"Come on, surprise me."
	]
	return lines[randi() % lines.size()]
	
func _random_nervous_line() -> String:
	var lines = [
		"I-I don't know about this one.."
	]
	return lines[randi() % lines.size()]
	
func _random_disappointed_line() -> String:
	var lines = [
		"Really..?",
		"Wow.",
		"Hmm"
	]
	return lines[randi() % lines.size()]
	

################# USER DIALOG #######################
func _random_neutral_user_line() -> String:
	var lines = [
		"I've got this. Let's Play."
	]
	return lines[randi() % lines.size()]
	
func _random_confident_user_line() -> String:
	var lines = [
		"Trust me. I'm winning this."
	]
	return lines[randi() % lines.size()]
	
func _random_flirty_user_line() -> String:
	var lines = [
		"With your smile..I feel unstoppable."
	]
	return lines[randi() % lines.size()]
	
func _random_cocky_user_line() -> String:
	var lines = [
		"You won't keep up."
	]
	return lines[randi() % lines.size()]
	
func _random_doubledown_user_line() -> String:
	var lines = [
		"I'm going all in."
	]
	return lines[randi() % lines.size()]
	

	
func _on_answer_1_button_pressed() -> void:
	dialog_mode = 1
	game_manager.pot_mood = 5
	game_manager.pot_affection = -1
	_check_dialog_mode()
	dialog_user.text = _random_neutral_user_line()

func _on_answer_2_button_pressed() -> void:
	dialog_mode = 1
	game_manager.pot_mood = 11
	game_manager.pot_affection = -1
	_check_dialog_mode()
	dialog_user.text = _random_confident_user_line()

func _on_answer_3_button_pressed() -> void:
	dialog_mode = 1
	game_manager.pot_mood = -1
	game_manager.pot_affection = 6
	_check_dialog_mode()
	dialog_user.text = _random_flirty_user_line()

func _on_answer_4_button_pressed() -> void:
	dialog_mode = 1
	game_manager.pot_mood = 4
	game_manager.pot_affection = 9
	_check_dialog_mode()
	dialog_user.text = _random_cocky_user_line()
