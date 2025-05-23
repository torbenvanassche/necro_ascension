class_name Player
extends CharacterBody3D

#movement
@export var movement_speed: float = 1.25

@export_range(0.1, 1, 0.1, "Higher value means snappier rotation") var rotation_speed: float = 0.1;
@export var camera_relative: bool = false;

@export var interaction_range: Area3D;
@onready var animation_player: AnimationPlayer = $Necromancer/AnimationPlayer;
var player_state: String;

var current_triggers: Array[Area3D];
var do_processing: bool = true;
var can_transform: bool = false;

var direction: Vector3 = Vector3.ZERO;

var animation_controller: AnimationMachine;

func _init() -> void:
	Manager.instance.player = self;
	
func _ready() -> void:
	if interaction_range:
		interaction_range.area_entered.connect(_on_enter);
		interaction_range.area_exited.connect(_on_leave);
		
	animation_controller = AnimationMachine.new(animation_player);

func _physics_process(_delta: float) -> void:
	player_state = "Idle"
	if do_processing:
		var input_dir := Input.get_vector("left", "right", "back", "forward").normalized()
		if camera_relative:
			direction = (Manager.instance.camera.global_basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
		else:
			direction = Vector3(input_dir.x, 0, -input_dir.y).normalized()
		if direction:
			velocity.x = direction.x * movement_speed
			velocity.z = direction.z * movement_speed
		else:
			velocity.x = move_toward(velocity.x, 0, movement_speed)
			velocity.z = move_toward(velocity.z, 0, movement_speed)
			
	if velocity != Vector3.ZERO:
		player_state = "Running_A";
		var target_rotation := atan2(direction.x, direction.z);
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed);
	else:
		player_state = "Idle";
	move_and_slide();

	animation_controller.animation_state = player_state;
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact();
	
func interact() -> void:
	if current_triggers.size() != 0:
		if current_triggers[0].has_method("on_interact"):
			current_triggers[0].on_interact();
	
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
