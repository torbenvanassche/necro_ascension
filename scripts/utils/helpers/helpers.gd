class_name Helpers extends Node

static func calculate_position(index: int, radius: float, angle_increment: float) -> Vector3:
	var total_angle := index * angle_increment;
	return Vector3(radius * cos(total_angle), 0, radius * sin(total_angle));

static func flatten_hierarchy(node: Node, internal: bool = false) -> Array[Node]:
	var arr: Array[Node] = [];
	for c in node.get_children(internal):
		arr.append(c)
		if c.get_child_count() > 0:
			arr.append_array(flatten_hierarchy(c));
	return arr;

static func vector2_to_id(vector: Vector2) -> int:
	var scaled_x: int = int(round(vector.x * 1000))
	var scaled_y: int = int(round(vector.y * 1000))
	var unique_id: int = (scaled_x * 31_622_776) + scaled_y  # Using a prime number multiplier for x

	if unique_id < 0:
		unique_id = abs(unique_id)
	
	return unique_id
	
static func get_aabb(area: Area3D) -> AABB:
	var global_aabb: AABB = AABB(Vector3(0, 0, 0), Vector3(0, 0, 0))
	
	for child in area.get_children():
		if child is CollisionShape3D and child.shape and child.shape is BoxShape3D:
			var collision_shape: CollisionShape3D = child
			var local_aabb: AABB = Helpers.get_shape_aabb(collision_shape.shape)
			global_aabb = collision_shape.global_transform * local_aabb
	return global_aabb
	
static func get_random_position_within_aabb(aabb: AABB) -> Vector3:
	var min_value: Vector3 = aabb.position
	var max_value: Vector3 = aabb.position + aabb.size
	return Vector3(randi_range(int(min_value.x), int(max_value.x)), 0, randi_range(int(min_value.z), int(max_value.z)))
	
static func get_shape_aabb(shape: BoxShape3D) -> AABB:
	return AABB(-shape.extents, shape.extents * 2)
