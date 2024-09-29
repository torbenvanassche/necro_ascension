class_name Player
extends CharacterBody3D

#movement
@export var speed = 5.0

#rotation
var current_rotation_y: float = 0;
@export var rotation_speed: float = 3.0;
@export var camera_relative: bool = false;
@export var rotate_player_on_input: bool = false;

@export var interaction_range: Area3D;
@export var sprite3D: AnimatedSprite3D;
var player_state: String;

@export_group("Jump")
@export var jump_height: float = 10;
@export var jump_time_to_peak: float = 0.5;
@export var jump_time_to_descent: float = 0.4;
@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak;
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak);
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent);

var current_triggers: Array[Area3D];
var do_processing: bool = true;
var can_transform: bool = false;

var animation_controller: AnimationMachine;

func _init():
	Manager.instance.player = self;
	
func get_custom_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func _ready():
	if interaction_range:
		interaction_range.area_entered.connect(_on_enter);
		interaction_range.area_exited.connect(_on_leave);
	
	if not sprite3D:
		Debug.warn("Sprite target to animate was not defined.")
		
	var animations: Array[AnimationControllerState];
	for anim_name in sprite3D.sprite_frames.get_animation_names():
		animations.append(AnimationControllerState.new(anim_name))
	animation_controller = AnimationMachine.new(sprite3D, animations)

func _physics_process(delta):	
	if Input.is_action_just_pressed("open_inventory"):
		SceneManager.instance.set_active_scene("inventory", SceneConfig.new())
		
	if Input.is_action_just_pressed(("interact")):
		interact();
		
	if do_processing:
		velocity.y += get_custom_gravity() * delta;

	if is_on_floor():
		player_state = "idle_down"
		velocity.y = 0;
		
	if do_processing:
		var direction: Vector3;
		var input_dir = Input.get_vector("left", "right", "back", "forward").normalized()
		if camera_relative:
			direction = (Manager.instance.camera.global_basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
		else:
			direction = Vector3(input_dir.x, 0, -input_dir.y).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			player_state = "walk_left" if direction.x < 0 else "walk_right"
			if velocity.z != 0:
				player_state = "walk_up" if direction.z < 0 else "walk_down"
		
			if rotate_player_on_input:
				var target_rotation_y = atan2(-direction.x, -direction.z)
				current_rotation_y = lerp_angle(current_rotation_y, target_rotation_y, rotation_speed * delta)
				rotation.y = current_rotation_y
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	
	animation_controller.animation_state = player_state;
	
func interact():
	if current_triggers.size() != 0:
		if current_triggers[0].has_method("on_interact"):
			current_triggers[0].on_interact();
	
func sort_areas_by_distance():
	current_triggers.sort_custom(func(a: Node3D, b: Node3D): return global_position.distance_squared_to(a.global_position) > global_position.distance_squared_to(b.global_position));

func _on_enter(body: Area3D):
	if !current_triggers.has(body):
		current_triggers.push_back(body);
		sort_areas_by_distance();
		if body.has_method("on_area_enter"):
			body.on_area_enter();
	
func _on_leave(body: Area3D):
	current_triggers.erase(body);
	if body.has_method("on_area_leave"):
		body.on_area_leave();
