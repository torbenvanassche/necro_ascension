extends Node

@export_group("Room Options")
@export var room_options: Array[PackedScene];
@export var floor_tile: PackedScene

@export_group("Generation parameters")
@export var level_area: AABB;
@export var room_amount: int = 1;

var rooms: Array[Room] = [];
var pathfinder: PathGenerator;

func _ready() -> void:
	_generate_rooms();
	_connect_rooms();
	
#step 1: Generate rooms.
func _generate_rooms() -> void:
	for i in range(room_amount):
		print(i)
	
func _connect_rooms() -> void:
	pathfinder = PathGenerator.new(rooms)
