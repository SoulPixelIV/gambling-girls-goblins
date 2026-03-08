extends Node

@onready var dialog: Label = $"../User_Interface/Dialog_Label"

func _ready() -> void:
	dialog.text = "test"
