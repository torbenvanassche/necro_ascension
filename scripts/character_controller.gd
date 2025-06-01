class_name Player
extends CharacterBody3D

@export var movement_speed: float = 1.25
@export_range(0.1, 1, 0.1, "Higher value means snappier rotation") var rotation_speed: float = 0.1;

@export var camera_relative: bool = false;

@export var interaction_range: Area3D;

@export var attack_area: Area3D;
@export var weapon_data: WeaponResource;

@onready var animation_tree: AnimationTree = $AnimationTree;
var player_state: String;

var current_triggers: Array[Area3D];
var do_processing: bool = true;

var direction: Vector3 = Vector3.ZERO;

var animation_controller: AnimationMachine;
@onready var creature_controller: CreatureController = $creature_holder;

@onready var right_hand: BoneAttachment3D = $Necromancer/Rig/Skeleton3D/BoneAttachment3D

func _init() -> void:
	Manager.instance.player = self;
	
func _ready() -> void:
	if interaction_range:
		interaction_range.area_entered.connect(_on_enter);
		interaction_range.area_exited.connect(_on_leave);
		
	if attack_area:
		attack_area.area_entered.connect(_on_attack_hit);
		
	animation_controller = AnimationMachine.new(animation_tree, "kay_skeleton");
	_setup_animations()
	
	var weapon_instance: Node3D = weapon_data.weapon_scene.instantiate();
	right_hand.add_child(weapon_instance)
	weapon_data.apply(weapon_instance);
	
func _setup_animations() -> void:
	animation_controller.add_state(AnimationControllerState.new("IWR", "parameters/IWR/blend_position", AnimationControllerState.StateType.BLEND))
	animation_controller.add_state(AnimationControllerState.new("attack_chop", "2H_Melee_Attack_Chop", AnimationControllerState.StateType.STATE))
	animation_controller.add_state(AnimationControllerState.new("summon", "Spellcast_Summon", AnimationControllerState.StateType.STATE))
	animation_controller.add_state(AnimationControllerState.new("interact", "Interact", AnimationControllerState.StateType.STATE))

	animation_controller.add_animation_end_callback(animation_controller.get_state("attack_chop").blend_path, update_movement.bind(true));
	animation_controller.add_animation_end_callback(animation_controller.get_state("summon").blend_path, update_movement.bind(true));
	animation_controller.add_animation_end_callback(animation_controller.get_state("interact").blend_path, update_movement.bind(true));
	
func update_movement(b: bool) -> void:
	do_processing = b;

func _physics_process(delta: float) -> void:
	player_state = "idle"
	var input_dir := Input.get_vector("left", "right", "back", "forward").normalized()
	if camera_relative:
		direction = (Manager.instance.camera.global_basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	else:
		direction = Vector3(input_dir.x, 0, -input_dir.y).normalized()
	
	if direction && do_processing:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
		
		var target_rotation := atan2(direction.x, direction.z);
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed);
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
	move_and_slide()

	var horizontal_speed := Vector3(velocity.x, 0, velocity.z).length();
	animation_controller.blend_state("IWR", clampf(horizontal_speed, 0.0, 2.0), delta)

	if horizontal_speed > 0.1:
		player_state = "running"
	else:
		player_state = "idle"
	move_and_slide();

	animation_controller.animation_state = player_state;
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact();
	
func interact() -> void:
	if current_triggers.size() != 0:
		if current_triggers[0].has_method("on_interact"):
			animation_controller.set_state_on_machine("interact");
			current_triggers[0].on_interact();
			do_processing = false;
	
func sort_areas_by_distance() -> void:
	current_triggers.sort_custom(func(a: Node3D, b: Node3D) -> float: return global_position.distance_squared_to(a.global_position) > global_position.distance_squared_to(b.global_position));

func _on_enter(body: Area3D) -> void:
	if !current_triggers.has(body):
		current_triggers.push_back(body);
		sort_areas_by_distance();
		if body.has_method("on_area_enter"):
			body.on_area_enter();
	
func _on_leave(body: Area3D) -> void:
	current_triggers.erase(body);
	if body.has_method("on_area_leave"):
		body.on_area_leave();
		
func _on_attack_hit(body: Area3D) -> void:
	var enemy: CreatureInstance = body.get_parent();
	if enemy is CreatureInstance:
		enemy.take_damage(weapon_data.calculate_damage());
