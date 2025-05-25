class_name Skeleton extends Node3D

var state_controller: AnimationMachine;

func _ready() -> void:
	state_controller = AnimationMachine.new($AnimationTree);
	state_controller.add_state(AnimationControllerState.new("summon", "parameters/summon/request", AnimationControllerState.StateType.ONESHOT));
	
	state_controller.one_shot("summon");
