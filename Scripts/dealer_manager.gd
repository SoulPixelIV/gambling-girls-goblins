extends Node

@onready var game_manager: Node = $"../Game_Manager"
@onready var mood_text: Label = $"../User_Interface/Dealer_Interface/Mood_Label"
@onready var affection_text: Label = $"../User_Interface/Dealer_Interface/Affection_Label"

var mood = 30.0
var affection = 30.0
