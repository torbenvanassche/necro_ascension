class_name Skeleton extends CreatureInstance

func _ready() -> void:
	super();
	state_controller.add_state(AnimationControllerState.new("spawn", "Spawn_Ground_Skeletons", AnimationControllerState.StateType.STATE));
	state_controller.add_animation_end_callback(state_controller.get_state("spawn").blend_path, update_processing.bind(true));
	update_processing(false);
	
	state_controller.set_state_on_machine("spawn");

func update_processing(b: bool) -> void:
	do_processing = b;
