extends Node

@export var rooms: Array[Room] = []
@export var floor_tile: PackedScene
var pathfinder: PathGenerator;

var _floating_point_factor: float = 10.0

func _ready() -> void:
	pathfinder = PathGenerator.new()
	connect_rooms(rooms[0], rooms[1])

	var start: Vector2 = Vector2(rooms[0].entrances[0].get_floor().global_position.x, rooms[0].entrances[0].get_floor().global_position.z)
	var end: Vector2 = Vector2(rooms[1].entrances[0].get_floor().global_position.x, rooms[1].entrances[0].get_floor().global_position.z)
	var path: PackedVector2Array = find_path(pathfinder, start, end)
	for node in path:
		var tile: Node3D = floor_tile.instantiate();
		add_child(tile);
		tile.global_position = Vector3(node.x, 0, node.y)
		tile.scale *= 0.9

func find_path(pathfinder: AStar2D, start: Vector2, end: Vector2) -> PackedVector2Array:
	# Generate IDs for the start and end positions
	var start_id: int = Helpers.vector2_to_id(start)
	var end_id: int = Helpers.vector2_to_id(end)

	# Find and return the path
	if pathfinder.has_point(start_id) and pathfinder.has_point(end_id):
		return pathfinder.get_point_path(start_id, end_id)
	else:
		print("No path found")
		return PackedVector2Array()

func connect_rooms(room1: Room, room2: Room) -> void:
	var entrance1: Vector2 = Vector2(room1.entrances[0].get_floor().global_position.x, room1.entrances[0].get_floor().global_position.z)
	var entrance2: Vector2 = Vector2(room2.entrances[0].get_floor().global_position.x, room2.entrances[0].get_floor().global_position.z)

	# Scale positions to a grid-like system using _floating_point_factor
	var start_x: float = roundf(minf(entrance1.x, entrance2.x) * _floating_point_factor)
	var end_x: float = roundf(maxf(entrance1.x, entrance2.x) * _floating_point_factor)
	var start_y: float = roundf(minf(entrance1.y, entrance2.y) * _floating_point_factor)
	var end_y: float = roundf(maxf(entrance1.y, entrance2.y) * _floating_point_factor)

	var positions: Dictionary = {}  # Map unique IDs to positions
	
	# Ensure the entrances are explicitly added before the loop
	var entrance1_id: int = Helpers.vector2_to_id(entrance1)
	var entrance2_id: int = Helpers.vector2_to_id(entrance2)

	if not pathfinder.has_point(entrance1_id):
		pathfinder.add_point(entrance1_id, entrance1)
	positions[entrance1_id] = entrance1

	if not pathfinder.has_point(entrance2_id):
		pathfinder.add_point(entrance2_id, entrance2)
	positions[entrance2_id] = entrance2

	# Generate positions between the two entrances
	for x in range(start_x, end_x + _floating_point_factor, _floating_point_factor):
		for y in range(start_y, end_y + _floating_point_factor, _floating_point_factor):
			var pos: Vector2 = Vector2(x / _floating_point_factor, y / _floating_point_factor)
			if rooms.all(func(r: Room) -> bool: return not r.is_point_inside(Vector3(pos.x, 0, pos.y))):
				var id: int = Helpers.vector2_to_id(pos)
				if not pathfinder.has_point(id): 
					pathfinder.add_point(id, pos)
				positions[id] = pos

	# Connect each position to its neighbors in all cardinal directions
	for id: int in positions.keys():
		var pos: Vector2 = positions[id]
		var neighbors: Array[Vector2] = [
			pos + Vector2(1.0, 0),  # East
			pos + Vector2(-1.0, 0), # West
			pos + Vector2(0, 1.0),  # North
			pos + Vector2(0, -1.0)  # South
		]

		for neighbor in neighbors:
			var neighbor_id: int = Helpers.vector2_to_id(neighbor)
			if positions.has(neighbor_id) and neighbor_id != id:
				if not pathfinder.are_points_connected(id, neighbor_id):
					pathfinder.connect_points(id, neighbor_id)
