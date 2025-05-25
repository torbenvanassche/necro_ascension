extends Camera3D

@export var target: Node3D
@export var follow_speed: float = 1.0
@export var rotation_speed: float = 0.25;

var initial_offset: Vector3
var initial_rotation: Quaternion;
var rotation_difference: Quaternion;

func _ready() -> void:
	Manager.instance.camera = self;
	
	if target:
		initial_offset = global_transform.origin - target.global_transform.origin
		
		initial_rotation = global_transform.basis.get_rotation_quaternion()
		look_at(target.global_transform.origin, Vector3.UP)
		var new_rotation: Quaternion = global_transform.basis.get_rotation_quaternion()
		rotation_difference = initial_rotation.inverse() * new_rotation;

func _physics_process(delta: float) -> void:
	if target:
		var target_position: Vector3 = target.global_transform.origin + initial_offset
		global_transform.origin = global_transform.origin.lerp(target_position, delta * follow_speed)

		look_at(target.global_transform.origin + (global_transform.origin - target_position) * rotation_speed, Vector3.UP)
		global_transform.basis *= Basis(rotation_difference)

func get_ray_hit_from_screen_point() -> Dictionary:
	var screen_point: Vector2 = get_viewport().get_mouse_position();
	var from := project_ray_origin(screen_point)
	var to := from + project_ray_normal(screen_point) * 1000.0

	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to)
	var result := space_state.intersect_ray(query)

	return result if result else {}
