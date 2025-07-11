class_name Skeleton extends CreatureInstance

@export var body_part_receiver: BodyPartReceiver;

func _ready() -> void:
	super();
	update_processing(false);
	
func apply_part(_part_name: String, part: MeshInstance3D) -> void:
	body_part_receiver.add_or_replace_piece(part)
		

func update_processing(b: bool) -> void:
	do_processing = b;
	
func take_damage(f: float) -> bool:
	if super(f):
		state_controller.set_state_on_machine("die");
		update_processing(false);
		return true;
	return false;
