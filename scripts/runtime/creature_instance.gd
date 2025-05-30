class_name CreatureInstance extends CharacterBody3D

@export var nav_agent: NavigationAgent3D;
var state_controller: AnimationMachine;
var man_pos: ManagedPosition;

@export_range(0.1, 1, 0.1, "Higher value means snappier rotation") var rotation_speed: float = 0.1;

var player_offset: Vector3;
var data: CreatureResource;
var do_processing: bool = true;

func _ready() -> void:
	state_controller = AnimationMachine.new($AnimationTree);
	state_controller.add_state(AnimationControllerState.new("IWR", "parameters/IWR/blend_position", AnimationControllerState.StateType.BLEND))
	
func setup(c_data: CreatureResource, managed_position: ManagedPosition) -> void:
	player_offset = managed_position.position;
	data = c_data;

func _physics_process(delta: float) -> void:
	update_target(Manager.instance.player.global_position + player_offset)
	if global_position.distance_to(nav_agent.target_position) > 0.05  && data && do_processing:
		var curr_location := global_transform.origin;
		var next_location := nav_agent.get_next_path_position()
		var new_vel := (next_location - curr_location).normalized() * data.move_speed;
		velocity = velocity.move_toward(new_vel, 0.25);
		move_and_slide()
	else:
		velocity = Vector3.ZERO;
		
	var horizontal_speed := Vector3(velocity.x, 0, velocity.z).length();
	state_controller.blend_state("IWR", clampf(horizontal_speed, 0.0, 2.0), delta)
		
	var target_rotation := atan2(velocity.x, velocity.z);
	rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed);
	
func update_target(target: Vector3) -> void:
	nav_agent.target_position = NavigationServer3D.map_get_closest_point(get_world_3d().navigation_map, target)
