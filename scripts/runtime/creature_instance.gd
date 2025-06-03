class_name CreatureInstance extends CharacterBody3D

@export var nav_agent: NavigationAgent3D;
var state_controller: AnimationMachine;
var man_pos: ManagedPosition;

@export_range(0.1, 1, 0.1, "Higher value means snappier rotation") var rotation_speed: float = 0.1;

var player_offset: Vector3;
var data: CreatureResource;
var do_processing: bool = true;

signal has_died();

var health: float;

func _ready() -> void:
	state_controller = AnimationMachine.new($AnimationTree, "kay_skeleton");
	state_controller.add_state(AnimationControllerState.new("IWR", "parameters/IWR/blend_position", AnimationControllerState.StateType.BLEND))
	nav_agent.velocity_computed.connect(_on_velocity_computed);
	
func setup(c_data: CreatureResource, managed_position: ManagedPosition) -> void:
	player_offset = managed_position.position;
	health = c_data.health;
	data = c_data;

func _physics_process(delta: float) -> void:
	update_target(Manager.instance.player.global_position + player_offset)
	if data && do_processing:
		var curr_location := global_transform.origin;
		var next_location := nav_agent.get_next_path_position()
		var new_vel := (next_location - curr_location).normalized() * data.move_speed;
		nav_agent.set_velocity(new_vel);
		move_and_slide()
	
func _on_velocity_computed(safe_velocity: Vector3) -> void:
	if global_position.distance_to(nav_agent.target_position) > 0.05:
		velocity = safe_velocity;
	
	var horizontal_speed := Vector3(safe_velocity.x, 0, safe_velocity.z).length();
	state_controller.blend_state("IWR", clampf(horizontal_speed, 0.0, 2.0), get_physics_process_delta_time())
		
	var target_rotation := atan2(safe_velocity.x, safe_velocity.z);
	rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed);
	
func update_target(target: Vector3) -> void:
	nav_agent.target_position = NavigationServer3D.map_get_closest_point(get_world_3d().navigation_map, target)
	
func take_damage(f: float) -> bool:
	health -= f;
	if health < 0:
		has_died.emit();
		return true;
	return false;
