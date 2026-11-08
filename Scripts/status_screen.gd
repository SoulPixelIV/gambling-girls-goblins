extends Node

@onready var game_manager: Node = $"../../Game_Manager"
@onready var dealer_manager = $"../../Dealer"
@onready var mood_stat_text: Label = $"Mood_Stat_Label"
@onready var affection_stat_text: Label = $"Affection_Stat_Label"

@onready var mood_icons: Array[TextureRect] = [
	$"Status1_Icon",
	$"Status2_Icon",
	$"Status3_Icon",
	$"Status4_Icon"
]
@onready var affection_icons: Array[TextureRect] = [
	$"Status5_Icon",
	$"Status6_Icon",
	$"Status7_Icon",
	$"Status8_Icon"
]

@onready var debuff1_text: Label = $"Status1_Debuff_Label"
@onready var debuff2_text: Label = $"Status2_Debuff_Label"
@onready var player_healthbar: Label = $"Pot_Text"
@onready var enemy_healthbar: Label = $"Pot_Text2"

var mood_tooltips = [
	"Boosts Player Attack",
	"Reduces Enemy Damage",
	"No more Self Damage",
	"Occasionally shield from Attack"
]

var affection_tooltips = [
	"7 can be changed to 6 or 8",
	"Queen counts as Ace",
	"Player deals 5 Damage on Draw",
	"Occasionally redraw on Bust"
]

func _ready() -> void:
	_update_betting_status()

func _update_betting_status():
	# Update Pot
	if game_manager.pot_mood == -1:
		mood_stat_text.text = "" 
	else:
		mood_stat_text.text = str(game_manager.pot_mood)
	
	if game_manager.pot_affection == -1:
		affection_stat_text.text = "" 
	else:
		affection_stat_text.text = str(game_manager.pot_affection)

	# Mood Buffs
	var mood_count = clampi(game_manager.mood_level - 1, 0, 4)
	_set_active_icons(mood_icons, mood_count, mood_tooltips)

	# Affection Buffs
	var affection_count = clampi(game_manager.affection_level - 1, 0, 4)
	_set_active_icons(affection_icons, affection_count, affection_tooltips)

	# Debuffs
	if game_manager.mood_level == 0:
		debuff1_text.text = "Enemy always Crits"
	else:
		debuff1_text.text = ""
		
	if game_manager.affection_level == 0:
		debuff2_text.text = "Landing on 19 is Bust" 
	else:
		debuff2_text.text = ""

func _set_active_icons(icons: Array[TextureRect], active_count: int, tooltips: Array):
	for i in range(icons.size()):
		icons[i].visible = i < active_count
		icons[i].tooltip_text = tooltips[i]
	
