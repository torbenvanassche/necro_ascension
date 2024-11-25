class_name PathGenerator
extends AStar2D

#var current_direction: Vector2 = Vector2.ZERO
#Ill use a dictionary for this
var directions: Dictionary = {}

#Redundant? Why would you need current node when you have acces to U and V
#var current_node: int;

func _compute_cost(u: int, v: int) -> float:
	var u_pos: Vector2 = get_point_position(u)
	var v_pos: Vector2 = get_point_position(v)

	var base_cost: float = u_pos.distance_to(v_pos)
	#Tried Manhattan distance but it seems to be the same, sum of the X and Y distances
	#var base_cost: float = abs(u_pos.x - v_pos.x) + abs(u_pos.y - v_pos.y)

	var movement_direction: Vector2 = (v_pos - u_pos).normalized()
	if directions.has(u): #Check if we have previous node in dictionary
		var previous_direction: Vector2 = directions[u] #Get direction
		if !movement_direction.is_equal_approx(previous_direction): #If its not a match we penalize the cost
			base_cost*=1.5
	#Add visited node's direction to dictionary
	directions[v] = movement_direction
	
	
	#Gonna leave this here
	#var alignment: float = movement_direction.dot(current_direction.normalized())
	#var directional_bias: float = pow(1.0 + max(0.0, 1.0 - alignment), 2)
	#if(u != current_node):
		#current_direction = current_direction.lerp(movement_direction, 0.5)
		#current_node = u;

	return base_cost
