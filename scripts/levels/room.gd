class_name Room extends Node3D

var entrances: Array[Entrance];

@export var no_floor_area: Area3D;
@onready var _collision_shape: CollisionShape3D = $Area3D/CollisionShape3D;

var _overlap_count: int = 0;

var _extents: Vector3;
var _position: Vector3;

func _ready() -> void:
	entrances.assign(Helpers.flatten_hierarchy(self, false).filter(func(n: Node) -> bool: return n is Entrance));
	_extents = _collision_shape.shape.size / 2;
	_position = _collision_shape.position;

func get_floor_positions() -> Array[Vector3]:
	var r_arr: Array[Vector3];
	r_arr.assign($floor.get_children().map(func(x: Node) -> Vector3: return x.global_position))
	return r_arr;

func is_point_inside(point: Vector3) -> bool:
	var local_point := no_floor_area.to_local(point)
	if _collision_shape.shape is BoxShape3D:
		return local_point.x >= _position.x - _extents.x and local_point.x <= _position.x + _extents.x and local_point.z >= _position.z - _extents.z and local_point.z <= _position.z + _extents.z
	return false;
	
func is_overlapping(other_room: Room) -> bool:
	var aabb: AABB = Helpers.get_aabb(no_floor_area)
	var room_aabb: AABB = Helpers.get_aabb(other_room.no_floor_area)
	print(aabb.intersects(room_aabb))
	return aabb.intersects(room_aabb)
