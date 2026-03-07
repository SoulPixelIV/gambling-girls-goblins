extends Node2D

var health = 26
var stand_on = 16
var stand_chance = 0.3
var deck = ["6H", "6D", "6C", "6S", "7H", "7D", "7C", "7S", "6H", "6D", "6C", "6S", "7H", "7D", "7C", "7S"]

func reset_deck():
	deck = ["6H", "6D", "6C", "6S", "7H", "7D", "7C", "7S", "6H", "6D", "6C", "6S", "7H", "7D", "7C", "7S"]
