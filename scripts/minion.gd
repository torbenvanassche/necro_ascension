class_name Skeleton extends CreatureInstance

func _ready() -> void:
	super();
	state_controller.add_state(AnimationControllerState.new("spawn", "Spawn_Ground_Skeletons", AnimationControllerState.StateType.STATE));
	state_controller.add_state(AnimationControllerState.new("die", "Death_A", AnimationControllerState.StateType.STATE))
	state_controller.add_animation_end_callback(state_controller.get_state("spawn").blend_path, update_processing.bind(true));
	state_controller.add_animation_end_callback(state_controller.get_state("die").blend_path, queue_free);
	update_processing(false);
	
	state_controller.set_state_on_machine("spawn");

func update_processing(b: bool) -> void:
	do_processing = b;
	
func take_damage(f: float) -> bool:
	if super(f):
		state_controller.set_state_on_machine("die");
		update_processing(false);
		return true;
	return false;
