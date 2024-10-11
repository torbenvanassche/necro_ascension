extends Camera3D

@export var target: Node3D
@export var follow_speed: float = 1.0

var initial_offset: Vector3
var initial_rotation: Quaternion

func _ready():
	Manager.instance.camera = self;
	
	if target:
		initial_offset = global_transform.origin - target.global_transform.origin
		initial_rotation = global_transform.basis.get_rotation_quaternion()

func _process(delta):
	if target:
		var target_position = target.global_transform.origin + initial_offset
		global_transform.origin = global_transform.origin.lerp(target_position, delta * follow_speed)

		look_at(target.global_transform.origin, Vector3.UP)
		global_transform.basis = Basis(initial_rotation) * global_transform.basis
