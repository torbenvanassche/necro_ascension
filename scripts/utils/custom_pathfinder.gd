class_name PathGenerator
extends AStar2D

var directions: Dictionary = {}

var _floating_point_factor: float = 10.0
var _path_margin: int = 2;
var _rooms: Array[Room] = []

func _init(rooms: Array[Room], path_margin: int = 2) -> void:
	_path_margin = path_margin;
	_rooms = rooms;

func _compute_cost(u: int, v: int) -> float:
	var u_pos: Vector2 = get_point_position(u)
	var v_pos: Vector2 = get_point_position(v)
	var base_cost: float = u_pos.distance_to(v_pos)

	var movement_direction: Vector2 = (v_pos - u_pos).normalized()
	if directions.has(u):
		var previous_direction: Vector2 = directions[u]
		if !movement_direction.is_equal_approx(previous_direction):
			base_cost += 2
	directions[v] = movement_direction
	return base_cost

func find_path(start: Vector2, end: Vector2) -> PackedVector2Array:
	# Generate IDs for the start and end positions
	var start_id: int = Helpers.vector2_to_id(start)
	var end_id: int = Helpers.vector2_to_id(end)

	# Find and return the path
	if has_point(start_id) and has_point(end_id):
		return get_point_path(start_id, end_id)
	else:
		print("No path found.")
		return PackedVector2Array()

func connect_rooms(room1: Room, room2: Room) -> void:
	var entrance1: Vector2 = Vector2(room1.entrances[0].get_floor().global_position.x, room1.entrances[0].get_floor().global_position.z)
	var entrance2: Vector2 = Vector2(room2.entrances[0].get_floor().global_position.x, room2.entrances[0].get_floor().global_position.z)

	# Scale positions to a grid-like system using _floating_point_factor
	var start_x: float = roundf(minf(entrance1.x, entrance2.x) * _floating_point_factor)
	var end_x: float = roundf(maxf(entrance1.x, entrance2.x) * _floating_point_factor)
	var start_y: float = roundf(minf(entrance1.y, entrance2.y) * _floating_point_factor)
	var end_y: float = roundf(maxf(entrance1.y, entrance2.y) * _floating_point_factor)
	
	start_x -= _path_margin * _floating_point_factor;
	start_y -= _path_margin * _floating_point_factor;
	end_x += _path_margin * _floating_point_factor;
	end_y += _path_margin * _floating_point_factor;

	var positions: Dictionary = {}  # Map unique IDs to positions
	
	# Ensure the entrances are explicitly added before the loop
	var entrance1_id: int = Helpers.vector2_to_id(entrance1)
	var entrance2_id: int = Helpers.vector2_to_id(entrance2)

	if not has_point(entrance1_id):
		add_point(entrance1_id, entrance1)
	positions[entrance1_id] = entrance1

	if not has_point(entrance2_id):
		add_point(entrance2_id, entrance2)
	positions[entrance2_id] = entrance2

	# Generate positions between the two entrances
	for x in range(start_x, end_x + _floating_point_factor, _floating_point_factor):
		for y in range(start_y, end_y + _floating_point_factor, _floating_point_factor):
			var pos: Vector2 = Vector2(x / _floating_point_factor, y / _floating_point_factor)
			if _rooms.all(func(r: Room) -> bool: return not r.is_point_inside(Vector3(pos.x, 0, pos.y))):
				var id: int = Helpers.vector2_to_id(pos)
				if not has_point(id): 
					add_point(id, pos)
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
				if not are_points_connected(id, neighbor_id):
					connect_points(id, neighbor_id)
