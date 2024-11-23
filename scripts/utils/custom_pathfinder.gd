class_name PathGenerator
extends AStar2D

var current_direction: Vector2 = Vector2.ZERO

func _compute_cost(u: int, v: int) -> float:
	var u_pos: Vector2 = get_point_position(u)
	var v_pos: Vector2 = get_point_position(v)

	var base_cost: float = u_pos.distance_to(v_pos)

	var movement_direction: Vector2 = (v_pos - u_pos).normalized()
	var alignment: float = movement_direction.dot(current_direction.normalized())
	var directional_bias: float = 1.0 + max(0.0, 1.0 - alignment)
	current_direction = movement_direction

	return base_cost * directional_bias
