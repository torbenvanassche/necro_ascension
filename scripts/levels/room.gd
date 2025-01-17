class_name Room extends Node3D

@export var entrances: Array[Entrance];

var colliders: Node3D;

#used to define the space other rooms cannot spawn
var forbidden_areas: Array[Area3D];

#used to set options for decoration and spawn positions
@export var decoration_options: ItemSelectorResource;
@export var decoration_spawn_positions: Array[Node3D];

func _ready() -> void:
	colliders = get_node("collision_container");
	if colliders != null:
		forbidden_areas.assign(colliders.get_children())
	entrances.assign(Helpers.flatten_hierarchy(self, false).filter(func(n: Node) -> bool: return n is Entrance));

func get_floor_positions() -> Array[Vector3]:
	var r_arr: Array[Vector3];
	r_arr.assign($floor.get_children().map(func(x: Node) -> Vector3: return x.global_position))
	return r_arr;

func is_point_inside(point: Vector3) -> bool:
	for area in forbidden_areas:
		var local_point := area.to_local(point)
		var _collision_shape: CollisionShape3D = area.get_node("CollisionShape3D");
		if _collision_shape.shape is BoxShape3D:
			var _extents: Vector3 = _collision_shape.shape.size / 2;
			var _position: Vector3 = _collision_shape.position;
			if local_point.x >= _position.x - _extents.x and local_point.x <= _position.x + _extents.x and local_point.z >= _position.z - _extents.z and local_point.z <= _position.z + _extents.z:
				return true;
	return false;
	
func is_overlapping(other_room: Room) -> bool:
	for area in forbidden_areas:
		var aabb: AABB = Helpers.get_aabb(area)
		for other_area in other_room.forbidden_areas:
			var room_aabb: AABB = Helpers.get_aabb(other_area)
			if aabb.intersects(room_aabb):
				return true;
	return false;
