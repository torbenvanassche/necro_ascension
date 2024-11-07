class_name CreatureInstance extends CharacterBody3D

@export var nav_agent: NavigationAgent3D;
var player_offset: Vector3;
var data: CreatureResource;
	
func setup(c_data: CreatureResource, offset: Vector3) -> void:
	tree_entered.connect(_teleport_start)
	player_offset = offset;
	data = c_data;
	
func _teleport_start() -> void:
	global_position = Manager.instance.player.global_position + player_offset;

func _physics_process(delta: float) -> void:
	update_target(Manager.instance.player.global_position + player_offset)
	if global_position.distance_to(nav_agent.target_position) > 0.05:
		var curr_location := global_transform.origin;
		var next_location := nav_agent.get_next_path_position()
		var new_vel := (next_location - curr_location).normalized() * data.move_speed;
		velocity = velocity.move_toward(new_vel, 0.25);
		move_and_slide()
	
func update_target(target: Vector3) -> void:
	nav_agent.target_position = target;
