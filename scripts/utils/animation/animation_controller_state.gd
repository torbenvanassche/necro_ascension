class_name AnimationControllerState extends Resource

@export var state_name: String;

@export var blend_path: String = ""
@export var blend_smooth_speed: float = 10.0
var state_type: StateType = StateType.NONE;
var blend_value: float = 0.0;

enum StateType {
	NONE,
	BLEND,
	ONESHOT,
	STATE,
	PARAMETER
}

func _init(id: String, blend_key: String, type: StateType) -> void:
	state_name = id;
	blend_path = blend_key;
	state_type = type;
	
func set_blend_value(target: float, delta: float) -> float:
	if state_type == StateType.BLEND:
		blend_value = lerp(blend_value, target, blend_smooth_speed * delta)
	return blend_value;
