class_name PathGenerator
extends AStar2D

var directions: Dictionary = {}

func _compute_cost(u: int, v: int) -> float:
	var u_pos: Vector2 = get_point_position(u)
	var v_pos: Vector2 = get_point_position(v)
	var base_cost: float = u_pos.distance_to(v_pos)

	var movement_direction: Vector2 = (v_pos - u_pos).normalized()
	if directions.has(u):
		var previous_direction: Vector2 = directions[u]
		if !movement_direction.is_equal_approx(previous_direction):
			base_cost += 2
	directions[v] = movement_direction
	return base_cost
