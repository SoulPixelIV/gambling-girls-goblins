extends Node2D

@onready var event_node = preload("res://Prefabs/event_node.tscn")
@onready var combat_node = preload("res://Prefabs/combat_node.tscn")
@onready var start_node = preload("res://Prefabs/start_node.tscn")
@onready var finish_node = preload("res://Prefabs/finish_node.tscn")
@onready var player_node = preload("res://Prefabs/player_node.tscn")
@onready var line_container: Node = $"../Overworld_Interface/Line_Container"
@onready var game_manager = get_parent().get_node("Game_Manager")

var grid_width = 8
var grid_height = 4
var cell_size = 60
var start_pos = Vector2(165, 30)

var player_node_instance
var is_moving = false
var all_nodes = []
var current_node
	
func get_all_grid_positions():
	var positions = []
	
	for x in range(grid_width):
		for y in range(grid_height):
			var pos = start_pos + Vector2(x * cell_size, y * cell_size)
			positions.append(pos)
	
	return positions
	
func get_random_positions(amount):
	var positions = get_all_grid_positions()
	positions.shuffle()
	
	return positions.slice(0, amount)

func _generate_dungeon():
	var positions = get_random_positions(8)
	
	#Set Start & Finish Nodes
	var start_index = randi() % positions.size() #Select Start Node
	var finish_index = randi() % positions.size() #Select Finish Node
	while finish_index == start_index:
		finish_index = randi() % positions.size()
	
	var nodes = []
	
	#Spawn Nodes
	for i in range(positions.size()):
		var node
		
		if i == start_index:
			node = start_node.instantiate()
			current_node = node
			player_node_instance = player_node.instantiate()
			add_child(player_node_instance)
		elif i == finish_index:
			node = finish_node.instantiate()
		else:
			#Chance to Spawn Combat Node
			if randf() < 0.5:
				node = combat_node.instantiate()
			else:
				node = event_node.instantiate()
			
		add_child(node)
		node.position = positions[i]
		node.node_clicked.connect(_on_node_clicked)
		
		#Set Player to Start Node
		if i == start_index:
			player_node_instance.position = node.position
		nodes.append(node)
		
	_connect_nodes(nodes)
	all_nodes = nodes
	update_available_nodes(all_nodes)
		
func _connect_nodes(nodes):
	var connected = [nodes[0]] #[0]
	var unconnected = nodes.duplicate() #[0,1,2,3,4,5,6,7]
	unconnected.erase(nodes[0]) #[1,2,3,4,5,6,7]
	
	while unconnected.size() > 0:
		var last_node = connected[connected.size() - 1]
		var nearest_node = null
		var min_dist = INF
		
		for node in unconnected:		
			var dist_to_target = last_node.position.distance_to(node.position)
			if dist_to_target < min_dist:
				min_dist = dist_to_target
				nearest_node = node
			
		_draw_connection(last_node.position, nearest_node.position)
		last_node.connected_nodes.append(nearest_node)
		nearest_node.connected_nodes.append(last_node)
		
		connected.append(nearest_node)
		unconnected.erase(nearest_node)

func _draw_connection(pos1, pos2):
	var line = Line2D.new()
	line.width = 2
	line.default_color = Color.AQUAMARINE
	line.points = [pos1, pos2]
	line_container.add_child(line)

#Event happens if Node is clicked
func _on_node_clicked(target_node):
	if is_moving:
		return
	if target_node not in current_node.connected_nodes:
		return

	is_moving = true

	var tween = create_tween()

	tween.tween_property(
		player_node_instance,
		"position",
		target_node.position,
		0.5
	)

	await tween.finished
	current_node = target_node
	update_available_nodes(all_nodes)
	
	#Check if landed Node is Combat
	if target_node.is_combat:
		game_manager._switch_game_mode(0)
	
	is_moving = false

#Show which Nodes are reachable
func update_available_nodes(nodes):
	for node in nodes:
		#Set Selected Node
		if node == current_node:
			node.set_available(true)
		#Set Connected Nodes
		elif node in current_node.connected_nodes:
			node.set_available(true)
		else:
			node.set_available(false)
