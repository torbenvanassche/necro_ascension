extends Node

@export var starting_room: Room;

@export_group("Room Options")
@export var room_options: Array[PackedScene];
@export var floor_tile: PackedScene

@export_group("Generation parameters")
@export var level_area: Area3D;
@export var room_amount: int = 1;
@export var max_attempts: int = 10;

var rooms: Array[Room] = [];
var pathfinder: PathGenerator;
	
#function that will create and connect the rooms. carving; not random placing and connecting
func _generate_rooms() -> void:
	pass
	
func _connect_rooms() -> void:
	pathfinder = PathGenerator.new(rooms)

func _is_within_bounds(room_instance: Room) -> bool:
	for area in room_instance.forbidden_areas:
		var aabb: AABB = Helpers.get_aabb(level_area)
		var room_aabb: AABB = Helpers.get_aabb(area)
		if aabb.encloses(room_aabb):
			return true;
	return false;
