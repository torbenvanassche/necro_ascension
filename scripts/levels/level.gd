extends Node

@export_group("Room Options")
@export var room_options: Array[PackedScene];
@export var floor_tile: PackedScene

@export_group("Generation parameters")
@export var level_area: Area3D;
@export var room_amount: int = 1;
@export var max_attempts: int = 50;

var rooms: Array[Room] = [];
var pathfinder: PathGenerator;

func _ready() -> void:
	print($Area3D2.overlaps_area($Area3D3))
	
	#_generate_rooms();
	#_connect_rooms();
	pass
	
func _generate_rooms() -> void:
	for i in range(room_amount):
		var attempts: int = 0
		var placed: bool = false
		while attempts < max_attempts and not placed:
			var room_instance: Room = room_options.pick_random().instantiate()
			var random_position: Vector3 = Helpers.get_random_position_within_aabb(Helpers.get_aabb(level_area))
			
			add_child(room_instance)
			room_instance.global_position = random_position
			
			var overlap := rooms.any(func(r: Room) -> bool: return room_instance.is_overlapping(r));
			if not overlap and _is_within_bounds(room_instance):
				print("generation success.")
				rooms.append(room_instance)
				placed = true
			else:
				room_instance.queue_free()
			attempts += 1
			
			if attempts == max_attempts:
				print("generation failed.")
	
func _connect_rooms() -> void:
	pathfinder = PathGenerator.new(rooms)

func _is_within_bounds(room_instance: Room) -> bool:
	var aabb: AABB = Helpers.get_aabb(level_area)
	var room_aabb: AABB = Helpers.get_aabb(room_instance.no_floor_area)
	var global_room_aabb := AABB(room_instance.global_transform.origin + room_aabb.position, room_aabb.size)
	return aabb.intersects(global_room_aabb)
