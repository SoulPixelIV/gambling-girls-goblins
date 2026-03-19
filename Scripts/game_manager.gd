extends Node

@onready var playing_card = preload("res://Prefabs/playing_card.tscn")
@onready var hand = $"../Hand"
@onready var enemy_hand = $"../Enemy_Hand"
@onready var dealer_manager = $"../Dealer"
@onready var dialog_manager = $"../Dialog_Manager"
@onready var status_screen: Node = $"../User_Interface/Status_Screen"
@onready var player_healthbar: ProgressBar = $"../User_Interface/Player_Healthbar"
@onready var enemy_healthbar: ProgressBar = $"../User_Interface/Enemy_Healthbar"
@onready var player_health: Label = $"../User_Interface/Player_Health"
@onready var enemy_health: Label = $"../User_Interface/Enemy_Health"
@onready var player_score_text: Label = $"../User_Interface/Player_Score"
@onready var enemy_score_text: Label = $"../User_Interface/Enemy_Score"
@onready var enemy_name_tag: Label = $"../User_Interface/Enemy_Name_Label"
@onready var final_player_score_text: Label = $"../User_Interface/Final_Score_Labels/Final_Player_Score"
@onready var final_enemy_score_text: Label = $"../User_Interface/Final_Score_Labels/Final_Enemy_Score"
@onready var combat_messages_text: Label = $"../User_Interface/Final_Score_Labels/Combat_Messages"
@onready var combat_messages2_text: Label = $"../User_Interface/Final_Score_Labels/Combat_Messages2"
@onready var hit_button = $"../User_Interface/Hit_Button"
@onready var stand_button = $"../User_Interface/Stand_Button"
@onready var tripple_button1 = $"../User_Interface/Tripple_Button1"
@onready var tripple_button2 = $"../User_Interface/Tripple_Button2"
@onready var tripple_button3 = $"../User_Interface/Tripple_Button3"
@onready var crazy_goblin_enemy = preload("res://Prefabs/crazy_goblin.tscn")
@onready var slime_enemy = preload("res://Prefabs/slime.tscn")
@onready var drunkard_enemy = preload("res://Prefabs/drunkard.tscn")

var enemy = null
var rand_enemy = null

var health = 42
var pot_mood = -1 #Betted Mood Points
var pot_affection = -1 #Betted Affection Points
var mood_level = 1
var affection_level = 1
var turn_state = -1 #Turnstate -1 -> First Enemy Draw | Turnstate 0 -> Normal Enemy Draw | Turnstate 1 -> Player Draw
var begin_fight = false #Wait for Dealer Betting Phase
var delay_timer = 2
var card_index = 0
var enemy_card_index = 0
var player_score = 0
var enemy_score = 0
var player_out = false
var enemy_out = false
var called_combat_resolve = false
var called_rng_value = false
var curr_damage = 0
var curr_enemy_damage = 0
var button_mode = 0
var last_player_card = null
var redraw_used = false
var double_down_active = false
var safe_used = false
var deck = ["2H", "2D", "2C", "2S", "3H", "3D", "3C", "3S", "4H", "4D", "4C", "4S", 
"5H", "5D", "5C", "5S", "6H", "6D", "6C", "6S", "7H", "7D", "7C", "7S", 
"8H", "8D", "8C", "8S", "9H", "9D", "9C", "9S", "10H", "10D", "10C", "10S", 
"JH", "JD", "JC", "JS", "QH", "QD", "QC", "QS", "KH", "KD", "KC", "KS", 
"AH", "AD", "AC", "AS"]

func _ready() -> void:
	randomize()
	
	spawn_new_enemy()
	
	player_healthbar.max_value = health #Set Maximum Healthbar
	player_health.text = str(health)
	
	#Remove Placeholder Texts
	combat_messages_text.text = ""
	combat_messages2_text.text = ""
	final_player_score_text.text = ""
	final_enemy_score_text.text = ""
	
func _process(delta: float) -> void:
	if begin_fight:
		#Enemys First Draw
		if turn_state == -1:
			spawn_enemy_playing_card(330 + 25 * enemy_card_index, 90)
			enemy_card_index += 1
			turn_state = 1
		
		#Enemys Turn
		if turn_state == 0 && !enemy_out && button_mode == 0:
			#Random Stand Chance
			if !called_rng_value:
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				if rng.randf() < enemy.stand_chance:
					enemy_out = true
				called_rng_value = true
				
			if enemy_score >= enemy.stand_on:
				enemy_out = true
			else:
				delay_timer -= delta
				if delay_timer < 0:
					spawn_enemy_playing_card(330 + 25 * enemy_card_index, 90)
					called_rng_value = false
					enemy_card_index += 1
					turn_state = 1
					delay_timer = 2
				
		#Enemy keeps going when Player is out
		if player_out:
			player_score_text.add_theme_color_override("font_color", Color(1, 0, 0))
			turn_state = 0
			
		#Player keeps going when Enemy is out
		if enemy_out:
			enemy_score_text.add_theme_color_override("font_color", Color(1, 0, 0))
			turn_state = 1
			
		#Damage Calculating Phase
		if player_out && enemy_out:
			delay_timer -= delta
			if delay_timer < 0:
				if !called_combat_resolve:
					resolve_combat()
					called_combat_resolve = true
				
func resolve_combat():
	await setup_result_screen()
	
	#Affection Level 0 Debuff: 19 is Bust
	if affection_level == 0 and player_score == 19:
		combat_messages_text.text = "Bad Affection! 19 counts as 22!"
		await get_tree().create_timer(2).timeout
		player_score = 22
		
	#Affection Level 4 Bonus: Tie deals 5 damage to Enemy
	if affection_level >= 4 and player_score == enemy_score:
		combat_messages_text.text = "Good Affection! Tie deals 5 Damage to enemy!"
		combat_messages2_text.text = ""
		await get_tree().create_timer(2).timeout
		
		curr_enemy_damage += 5
		await show_enemy_final_damage()
		pot_mood = -1
		pot_affection = -1
		status_screen._update_betting_status()
		await payout_bet("player")
		
		reset_game_round()
		return
		
	if player_score == enemy_score and affection_level < 4:
		combat_messages_text.text = "It's a tie!"
		combat_messages2_text.text = ""
		await get_tree().create_timer(2).timeout
		combat_messages_text.text = ""
		
		pot_mood = -1
		pot_affection = -1
		status_screen._update_betting_status()
		await payout_bet("none")
		
		reset_game_round()
		return
	
	#PLAYER LOSES
	if player_score > 21:
		await show_self_damage()
		await show_final_damage()
		await payout_bet("enemy")
	#ENEMY LOSES
	if enemy_score > 21:
		await show_enemy_self_damage()
		await show_enemy_final_damage()
		await payout_bet("player")
	#PLAYER WINS
	if (player_score > enemy_score && player_score <= 21) || (enemy_score > 21 && player_score <= 21):
		await show_player_damage()
		if player_score == 21:
			await show_player_crit()
		if enemy_score > 21:
			await show_enemy_bust_protection()
		await show_enemy_final_damage()
		await payout_bet("player")
	#ENEMY WINS
	if (enemy_score > player_score && enemy_score <= 21) || (player_score > 21 && enemy_score <= 21):
		await show_enemy_damage()
		#Mood Level 0 Debuff: Enemy always Crits
		if mood_level == 0 or enemy_score == 21:
			await show_enemy_crit()
		if player_score > 21:
			await show_bust_protection()			
		await show_final_damage()
		await payout_bet("enemy")
		
	#Check if Player died
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		
	#Check if Enemy died
	if enemy.health <= 0:
		spawn_new_enemy()
	
	reset_game_round()
		
func _on_hit_button_pressed() -> void:
	if button_mode == 0:
		#Draw Card
		if turn_state == 1 && !player_out:
			spawn_playing_card(168 + 25 * card_index, 192)
			card_index += 1
			
			#Double Down Check
			if double_down_active:
				player_out = true
			
			turn_state = 0
	elif button_mode == 1:
		choose_ace_value(1)
		
func _on_stand_button_pressed() -> void:
	if button_mode == 0:
		if card_index > 0:
			player_out = true
	elif button_mode == 1:
		choose_ace_value(11)
	
func choose_ace_value(value):
	player_score += value
	player_score_text.text = str(player_score)

	# Ass-Modus verlassen
	button_mode = 0
	hit_button.text = "Hit"
	stand_button.text = "Stand"

	# Bust check
	if player_score > 21:
		player_out = true

	# Enemy Turn starten
	turn_state = 0
	
func choose_seven_value(value):
	player_score += value
	player_score_text.text = str(player_score)

	button_mode = 0
	dialog_manager.dialog_mode = 1
	dialog_manager._check_dialog_mode()

	if player_score > 21:
		player_out = true

	#Enemy Turn starten
	turn_state = 0
		
func spawn_playing_card(x, y):
	if deck.size() > 0:
		var rand_card_index = randi_range(0, deck.size() - 1) #Select Random Card from Deck
		var card_instance = playing_card.instantiate()
		card_instance.card_played.connect(_on_card_played) #Receive Card Value from Instantiated Card
		card_instance.value = deck[rand_card_index] #Give Created Card Value
		card_instance.game_manager = self
		deck.remove_at(rand_card_index) #Remove Card from Deck
		hand.add_child(card_instance)
		card_instance.position = Vector2(x, y)
		last_player_card = card_instance
		
func spawn_enemy_playing_card(x, y):
	if enemy != null:
		if enemy.deck.size() > 0:
			var rand_card_index2 = randi_range(0, enemy.deck.size() - 1) #Select Random Card from Deck
			var enemy_card_instance = playing_card.instantiate()
			enemy_card_instance.card_played.connect(_on_card_played_enemy) #Receive Card Value from Instantiated Card
			enemy_card_instance.value = enemy.deck[rand_card_index2] #Give Created Card Value
			enemy_card_instance.game_manager = self
			enemy.deck.remove_at(rand_card_index2) #Remove Card from Deck
			enemy_hand.add_child(enemy_card_instance)
			enemy_card_instance.position = Vector2(x, y)
			
func _on_card_played(value, card_id):
	if card_id.begins_with("A") or (card_id.begins_with("Q") and affection_level >= 3):
		button_mode = 1
	elif value == 7 and affection_level >= 2:
		button_mode = 2
	else:
		player_score += value
		player_score_text.text = str(player_score)

		#Check if Player is over 21
		if player_score > 21:
			#Affection Level 5 Bonus: Occasionally redraw last Card on Bust
			if affection_level >= 5 and !redraw_used:
				var rng = RandomNumberGenerator.new()
				rng.randomize()

				if rng.randf() < 0.25:
					combat_messages_text.text = "Good Affection! You redraw the last card!"
					await get_tree().create_timer(2.5).timeout
					combat_messages_text.text = ""

					redraw_used = true

					if last_player_card != null:
						last_player_card.queue_free()

					player_score -= value
					player_score_text.text = str(player_score)

					spawn_playing_card(168 + 25 * (card_index - 1), 192)
					return

			player_out = true
		
	#Change Button Texts
	if button_mode == 0:
		hit_button.text = "Hit"
		stand_button.text = "Stand"
	if button_mode == 1:
		hit_button.text = "Count as 1"
		stand_button.text = "Count as 11"
	if button_mode == 2:
		dialog_manager.dialog_mode = 2
		dialog_manager._check_dialog_mode()
		tripple_button1.text = "Count as 6"
		tripple_button2.text = "Count as 7"	
		tripple_button3.text = "Count as 8"	
	
func _on_card_played_enemy(value, card_id):
	if card_id.begins_with("A"):
		if enemy_score + 11 > 21:
			enemy_score += 1
		else:
			enemy_score += 11
		enemy_score_text.text = str(enemy_score)
	else:
		enemy_score += value
		enemy_score_text.text = str(enemy_score)
	
	#Check if Enemy is over 21
	if enemy_score > 21:
		enemy_out = true

func setup_result_screen():
	player_score_text.add_theme_color_override("font_color", Color(1, 1, 1))
	enemy_score_text.add_theme_color_override("font_color", Color(1, 1, 1))
	player_score_text.text = ""
	enemy_score_text.text = ""
	final_player_score_text.text = str("Player [" + str(player_score) + "]")
	final_enemy_score_text.text = str("Enemy [" + str(enemy_score) + "]")
	#Delete All Playing Cards
	for hand_child in hand.get_children():
		hand_child.queue_free()
	for enemy_hand_child in enemy_hand.get_children():
		enemy_hand_child.queue_free()
	await get_tree().create_timer(1).timeout
		
func show_self_damage():
	#Mood Level 4 Bonus: No Self Damage on Bust
	if mood_level >= 4:
		combat_messages_text.text = "Good Mood! No Self Damage from Bust!"
		combat_messages2_text.text = ""
		await get_tree().create_timer(2).timeout
		combat_messages_text.text = ""
		return
	
	var calc_self_damage = player_score - 21
	curr_damage += calc_self_damage
	combat_messages_text.text = "You receive %d Self Damage!" % calc_self_damage
	combat_messages2_text.text = "Total Self Damage: %d" % curr_damage
	await get_tree().create_timer(2).timeout
	
func show_enemy_self_damage():
	var calc_enemy_self_damage = enemy_score - 21
	curr_enemy_damage += calc_enemy_self_damage
	combat_messages_text.text = "Enemy receives %d Self Damage!" % calc_enemy_self_damage
	combat_messages2_text.text = "Total Damage: %d" % curr_enemy_damage
	await get_tree().create_timer(2).timeout
	
func show_enemy_damage():
	var calc_enemy_damage = 0
	
	#Mood Level 5 Bonus: Occasionally shields from Enemy Attack
	if mood_level >= 5:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		if rng.randf() < 0.3:
			combat_messages_text.text = "Good Mood! Enemy Attack was completly shielded!"
			combat_messages2_text.text = ""
			await get_tree().create_timer(2).timeout
			combat_messages_text.text = ""
			return
	
	if player_score > 21:
		calc_enemy_damage = enemy_score
	else:
		calc_enemy_damage = enemy_score - player_score 
		
	#Mood Level 3 Bonus: Player receives half Damage
	if mood_level >= 3:
		calc_enemy_damage = int(calc_enemy_damage / 2)
	
	curr_damage += calc_enemy_damage
	combat_messages_text.text = "You receive %d Damage from the Enemy!" % calc_enemy_damage
	combat_messages2_text.text = "Total Self Damage: %d" % curr_damage
	await get_tree().create_timer(2).timeout
	
func show_player_damage():
	var calc_player_damage = 0
	if enemy_score > 21:
		calc_player_damage = player_score
	else:
		calc_player_damage = player_score - enemy_score 
	#Mood level 2 Bonus: 1.5x Damager
	if mood_level >= 2:
		calc_player_damage = int(calc_player_damage * 1.5)
		
	curr_enemy_damage += calc_player_damage
	combat_messages_text.text = "Enemy receives %d Damage from the Player!" % calc_player_damage
	combat_messages2_text.text = "Total Damage: %d" % curr_enemy_damage
	await get_tree().create_timer(2).timeout
	
func show_enemy_crit():
	curr_damage = curr_damage * 2
	if mood_level == 0:
		combat_messages_text.text = "Bad Mood! Enemy deals twice the Damage"
	else:
		combat_messages_text.text = "Enemy deals twice the Damage (Crit Bonus)"
	combat_messages2_text.text = "Total Self Damage: %d" % curr_damage
	await get_tree().create_timer(2).timeout
	
func show_player_crit():
	curr_enemy_damage = curr_enemy_damage * 2
	combat_messages_text.text = "Player deals twice the Damage (Crit Bonus)"
	combat_messages2_text.text = "Total Damage: %d" % curr_enemy_damage
	await get_tree().create_timer(2).timeout
	
func show_bust_protection():
	curr_damage = curr_damage / 2
	combat_messages_text.text = "Player receives half the Damage (Bust Protection)"
	combat_messages2_text.text = "Total Self Damage: %d" % curr_damage
	await get_tree().create_timer(2).timeout
	
func show_enemy_bust_protection():
	curr_enemy_damage = curr_enemy_damage / 2
	combat_messages_text.text = "Enemy receives half the Damage (Bust Protection)"
	combat_messages2_text.text = "Total Damage: %d" % curr_enemy_damage
	await get_tree().create_timer(2).timeout
	
func show_final_damage():
	combat_messages_text.text = "Total Self Damage: %d" % curr_damage
	combat_messages2_text.text = ""
	health -= curr_damage
	player_healthbar.value = health
	player_health.text = str(health)
	curr_damage = 0
	await get_tree().create_timer(2).timeout
	
func payout_bet(state):
	if state == "player":
		if pot_mood != -1:
			dealer_manager.mood += pot_mood
			combat_messages_text.text = "Dealer's Mood went up by " + str(pot_mood)
			pot_mood = -1
			await get_tree().create_timer(2).timeout
		if pot_affection != -1:
			dealer_manager.affection += pot_affection
			combat_messages_text.text = "Dealer's Affection went up by " + str(pot_affection)
			pot_affection = -1
			await get_tree().create_timer(2).timeout
	elif state == "enemy":
		if pot_mood != -1:
			dealer_manager.mood -= pot_mood
			combat_messages_text.text = "Dealer's Mood went down by " + str(pot_mood)
			pot_mood = -1
			await get_tree().create_timer(2).timeout
		if pot_affection != -1:
			dealer_manager.affection -= pot_affection
			combat_messages_text.text = "Dealer's Affection went down by " + str(pot_affection)
			pot_affection = -1
			await get_tree().create_timer(2).timeout
	elif state == "none":
		combat_messages_text.text = "No one wins the bet!"
		await get_tree().create_timer(2).timeout
		combat_messages_text.text = ""
		return
		
	dealer_manager._update_dealer_stats()
	status_screen._update_betting_status()
	
func show_enemy_final_damage():
	combat_messages_text.text = "Total Damage: %d" % curr_enemy_damage
	combat_messages2_text.text = ""
	enemy.health -= curr_enemy_damage
	enemy_healthbar.value = enemy.health
	enemy_health.text = str(enemy.health)
	curr_enemy_damage = 0
	await get_tree().create_timer(2).timeout

func reset_game_round():
	turn_state = -1
	delay_timer = 2
	card_index = 0
	enemy_card_index = 0
	player_score = 0
	enemy_score = 0
	player_out = false
	enemy_out = false
	called_combat_resolve = false
	called_rng_value = false
	curr_damage = 0
	curr_enemy_damage = 0
	deck = ["2H", "2D", "2C", "2S", "3H", "3D", "3C", "3S", "4H", "4D", "4C", "4S", 
	"5H", "5D", "5C", "5S", "6H", "6D", "6C", "6S", "7H", "7D", "7C", "7S", 
	"8H", "8D", "8C", "8S", "9H", "9D", "9C", "9S", "10H", "10D", "10C", "10S", 
	"JH", "JD", "JC", "JS", "QH", "QD", "QC", "QS", "KH", "KD", "KC", "KS", 
	"AH", "AD", "AC", "AS"]
	enemy.reset_deck()
	combat_messages_text.text = ""
	combat_messages2_text.text = ""
	final_player_score_text.text = ""
	final_enemy_score_text.text = ""
	player_score_text.add_theme_color_override("font_color", Color(1, 1, 1))
	enemy_score_text.add_theme_color_override("font_color", Color(1, 1, 1))
	dialog_manager.dialog_mode = 0
	dialog_manager._check_dialog_mode()
	begin_fight = false
	redraw_used = false
	last_player_card = null
	double_down_active = false
	safe_used = false

func spawn_new_enemy():
	if enemy != null:
		enemy.queue_free()

	#Spawn Random Enemy
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	if rng.randf() < 0.33:
		rand_enemy = crazy_goblin_enemy
		enemy_name_tag.text = "Crazy Goblin"
	elif rng.randf() < 0.66:
		rand_enemy = slime_enemy
		enemy_name_tag.text = "Slime"
	else:
		rand_enemy = drunkard_enemy
		enemy_name_tag.text = "Drunkard"

	enemy = rand_enemy.instantiate()
	add_child(enemy)
	enemy.position = Vector2(530, 130)
	enemy.scale = Vector2(2, 2)

	#Update UI
	enemy_healthbar.max_value = enemy.health
	enemy_healthbar.value = enemy.health
	enemy_health.text = str(enemy.health)

func _on_tripple_button_1_pressed() -> void:
	if button_mode == 2:
		choose_seven_value(6)

func _on_tripple_button_2_pressed() -> void:
	if button_mode == 2:
		choose_seven_value(7)

func _on_tripple_button_3_pressed() -> void:
	if button_mode == 2:
		choose_seven_value(8)

func _on_double_button_pressed() -> void:
	if turn_state == 1 and !player_out and !enemy_out and !double_down_active and !safe_used:
		if card_index > 0:
			double_down_active = true
			
			# Einsatz verdoppeln
			if pot_mood != -1:
				pot_mood *= 2
			if pot_affection != -1:
				pot_affection *= 2
				
			#Update Dialog
			dialog_manager.dialog_user.text = dialog_manager._random_doubledown_user_line()
			status_screen._update_betting_status()
			combat_messages_text.text = "Double Down! Bet doubled, you draw only one more card!"
			await get_tree().create_timer(2).timeout
			combat_messages_text.text = ""

func _on_safe_button_pressed() -> void:
	if !safe_used and !player_out and !double_down_active:
		if card_index > 0:
			safe_used = true	
			#Reduce Bet
			if pot_mood > 0:
				pot_mood = int(pot_mood / 2)
			if pot_affection > 0:
				pot_affection = int(pot_affection / 2)
				
			status_screen._update_betting_status()
			combat_messages_text.text = "Safe! Bet halfed."
			await get_tree().create_timer(2).timeout
			combat_messages_text.text = ""
