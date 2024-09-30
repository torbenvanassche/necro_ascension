class_name Player
extends CharacterBody3D

#movement
@export var speed = 5.0

@export var camera_relative: bool = false;
var heading: String = "down";

@export var interaction_range: Area3D;
@export var sprite3D: AnimatedSprite3D;
var player_state: String;

var current_triggers: Array[Area3D];
var do_processing: bool = true;
var can_transform: bool = false;

var animation_controller: AnimationMachine;

func _init():
	Manager.instance.player = self;
	
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
	animation_controller.one_shot_ended.connect(func(): do_processing = true)

func _physics_process(delta):
	player_state = "idle"
	if Input.is_action_just_pressed("open_inventory"):
		SceneManager.instance.set_active_scene("inventory", SceneConfig.new())
		
	if Input.is_action_just_pressed(("interact")):
		interact();
		
	var direction: Vector3 = Vector3.ZERO;
	if do_processing:
		var input_dir = Input.get_vector("left", "right", "back", "forward").normalized()
		if camera_relative:
			direction = (Manager.instance.camera.global_basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
		else:
			direction = Vector3(input_dir.x, 0, -input_dir.y).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			
	if velocity != Vector3.ZERO:
		player_state = "walk";
		if velocity.x != 0:
			heading = "left" if direction.x < 0 else "right"
		if velocity.z != 0:
			heading = "up" if direction.z < 0 else "down"
	else:
		player_state = "idle";
	move_and_slide()
	
	if Input.is_action_just_pressed(("attack")):
		animation_controller.one_shot("%s_%s" % ["attack", heading])
		velocity = Vector3.ZERO;
		do_processing = false;
	animation_controller.animation_state = "%s_%s" % [player_state, heading];
	
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
