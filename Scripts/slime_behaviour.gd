extends Node2D

var health = 7
var stand_on = 18
var stand_chance = 0.15
var deck = ["2H", "2D", "2C", "2S", "3H", "3D", "3C", "3S", "4H", "4D", "4C", "4S", 
"5H", "5D", "5C", "5S"]

func reset_deck():
	deck = ["2H", "2D", "2C", "2S", "3H", "3D", "3C", "3S", "4H", "4D", "4C", "4S", 
"5H", "5D", "5C", "5S"]
