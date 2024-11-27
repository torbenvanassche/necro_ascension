extends Node

var rooms: Array[Room] = [];
@export var floor_tile: PackedScene
@onready var pathfinder: PathGenerator;

func _ready() -> void:
	_generate_rooms();
	_connect_rooms();
	
#step 1: Generate rooms.
func _generate_rooms() -> void:
	pass
	
func _connect_rooms() -> void:
	pathfinder = PathGenerator.new(rooms)
