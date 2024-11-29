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
	var global_aabb: AABB = AABB()
	
	for child in area.get_children():
		if child is CollisionShape3D and child.shape:
			var collision_shape: CollisionShape3D = child
			var local_aabb: AABB = Helpers.get_shape_aabb(collision_shape.shape)
			
			var global_transform: Transform3D = collision_shape.global_transform
			var transformed_aabb: AABB = _transform_aabb(local_aabb, global_transform)
			global_aabb = global_aabb.merge(transformed_aabb)
	return global_aabb
	
static func _transform_aabb(aabb: AABB, transform: Transform3D) -> AABB:
	var corners: Array[Vector3] = []
	for i in range(8):
		corners.append(transform * aabb.get_endpoint(i))
		
	var mi: Vector3 = corners[0]
	var ma: Vector3 = corners[0]
	for corner in corners:
		mi = mi.min(corner)
		ma = ma.max(corner)
	
	return AABB(mi, ma - mi)

	
static func get_random_position_within_aabb(aabb: AABB) -> Vector3:
	var min: Vector3 = aabb.position
	var max: Vector3 = aabb.position + aabb.size
	return Vector3(randi_range(int(min.x), int(max.x)),randi_range(int(min.y), int(max.y)), randi_range(int(min.z), int(max.z)))
	
static func get_shape_aabb(shape: Shape3D) -> AABB:
	var box_shape: BoxShape3D = shape
	return AABB(-box_shape.size / 2.0, box_shape.size)
