class_name AnimationControllerState extends Resource

@export var state_name: String;
@export var type: StateType;

enum StateType { BLEND, TRANSITION, STATE }

func _init(prop_type: StateType, id: String) -> void:
	state_name = id;
	type = prop_type;
