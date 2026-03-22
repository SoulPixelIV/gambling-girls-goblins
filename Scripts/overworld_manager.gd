extends Node

@onready var event_node = preload("res://Prefabs/event_node.tscn")
@onready var start_node = preload("res://Prefabs/start_node.tscn")
@onready var finish_node = preload("res://Prefabs/finish_node.tscn")

@onready var line_container: Node = $"../Overworld_Interface/Line_Container"

var grid_width = 8
var grid_height = 4
var cell_size = 60
var start_pos = Vector2(165, 30)
	
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
	
	#Select Start Node
	var start_index = randi() % positions.size()
	
	#Select Finish Node
	var finish_index = randi() % positions.size()
	
	while finish_index == start_index:
		finish_index = randi() % positions.size()
	
	var nodes = []
	
	for i in range(positions.size()):
		var node
		
		if i == start_index:
			node = start_node.instantiate()
		elif i == finish_index:
			node = finish_node.instantiate()
		else:
			node = event_node.instantiate()
			
		add_child(node)
		node.position = positions[i]
		nodes.append(node)
		
		_connect_nodes(nodes)
		
func _connect_nodes(nodes):
	var connected = [nodes[0]]
	var unconnected = nodes.duplicate()
	unconnected.erase(nodes[0])
	
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
		
		connected.append(nearest_node)
		unconnected.erase(nearest_node)

func _draw_connection(pos1, pos2):
	var line = Line2D.new()
	add_child(line)
	line.width = 2
	line.default_color = Color.AQUAMARINE
	line.points = [pos1, pos2]
	line_container.add_child(line)
