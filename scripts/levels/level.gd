extends Node

@export var rooms: Array[Room] = [];
@export var floor_tile: PackedScene;

func _ready() -> void: 
	connect_rooms(rooms[0], rooms[1])

func connect_rooms(room1: Room, room2: Room) -> void:
	var entrance1 := room1.entrances[0].get_floor();
	var entrance2 := room2.entrances[0].get_floor();
	
