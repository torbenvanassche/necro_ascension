class_name Skeleton extends CreatureInstance

var body_part_receiver: BodyPartReceiver;
var donor_script: Script = preload("res://scripts/body_parts/body_part_receiver.gd")

func _ready() -> void:
	super();
	state_controller.add_state(AnimationControllerState.new("spawn", "Spawn_Ground_Skeletons", AnimationControllerState.StateType.STATE));
	state_controller.add_state(AnimationControllerState.new("die", "Death_A", AnimationControllerState.StateType.STATE))
	state_controller.add_animation_end_callback(state_controller.get_state("spawn").blend_path, update_processing.bind(true));
	state_controller.add_animation_end_callback(state_controller.get_state("die").blend_path, queue_free);
	update_processing(false);
	
	var skeleton: Skeleton3D = $Rig/Skeleton3D;
	skeleton.set_script(donor_script);
	body_part_receiver = skeleton;
	
	state_controller.set_state_on_machine("spawn");
	
func apply_parts(parts: Dictionary[String, MeshInstance3D]) -> void:
	for p: String in parts.keys():
		body_part_receiver.add_or_replace_piece(parts[p])

func update_processing(b: bool) -> void:
	do_processing = b;
	
func take_damage(f: float) -> bool:
	if super(f):
		state_controller.set_state_on_machine("die");
		update_processing(false);
		return true;
	return false;
