extends Control

signal node_clicked(node)

@onready var texture_rect: TextureRect = $TextureRect

@export var hover_enabled = true
@export var is_combat = false
@export var is_heal = false
@export var combated_finished = false

var connected_nodes = []

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)

func _process(delta: float) -> void:
	if combated_finished:
		texture_rect.texture = preload("res://Textures/Nodes/event_node.png")

func _on_mouse_entered():
	if hover_enabled:
		scale = Vector2(1.4, 1.4)

func _on_mouse_exited():
	scale = Vector2(1, 1)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("node_clicked", self)

func set_available(active):
	if active:
		modulate = Color.WHITE
	else:
		modulate = Color(0.4, 0.4, 0.4, 1)
