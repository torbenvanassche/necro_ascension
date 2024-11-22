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
	return int(roundf(vector.x) * 1_000 + roundf(vector.y) + 1_000_000)
