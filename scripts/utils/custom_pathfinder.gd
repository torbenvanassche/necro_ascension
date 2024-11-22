class_name PathGenerator extends AStar2D

# Current movement direction for biasing the pathfinding
var current_direction: Vector2 = Vector2.ZERO

# Override _compute_cost to calculate movement costs
func _compute_cost(u: int, v: int) -> float:
	# Get the positions of the points
	var u_pos: Vector2 = get_point_position(u)
	var v_pos: Vector2 = get_point_position(v)
	
	# Base cost is the distance between the points
	var base_cost: float = u_pos.distance_to(v_pos)
	
	# Calculate the movement direction between the points
	var movement_direction: Vector2 = (v_pos - u_pos).normalized()
	
	# Calculate alignment with current movement direction using the dot product
	var alignment: float = movement_direction.dot(current_direction.normalized())
	var directional_bias: float = 1.0 + (1.0 - alignment) ** 2
	
	# Return the adjusted cost
	return base_cost * directional_bias;
