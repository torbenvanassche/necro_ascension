class_name Helpers extends Node

static func calculate_position(index: int, radius: float, angle_increment: float) -> Vector3:
	var total_angle := index * angle_increment;
	return Vector3(radius * cos(total_angle), 0, radius * sin(total_angle));
