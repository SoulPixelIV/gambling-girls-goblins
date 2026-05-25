extends Control

signal node_clicked(node)

@export var hover_enabled = true

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)

func _on_mouse_entered():
	if hover_enabled:
		scale = Vector2(1.4, 1.4)

func _on_mouse_exited():
	scale = Vector2(1, 1)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("node_clicked", self)
