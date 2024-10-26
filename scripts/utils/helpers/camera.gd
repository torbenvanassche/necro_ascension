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
