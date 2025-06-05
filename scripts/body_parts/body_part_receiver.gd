class_name BodyPartReceiver
extends Skeleton3D

@export var donor: PackedScene
@export var arm_left: MeshInstance3D

func _ready() -> void:
	var part_donor := donor.instantiate() as BodyPartDonor

	# Store transform of current arm before replacing
	var original_global_transform := arm_left.global_transform

	# Remove the old arm if it's still in the scene
	if is_instance_valid(arm_left) and arm_left.get_parent() == self:
		remove_child(arm_left)
		arm_left.queue_free()

	# Prepare the new donor arm
	var donor_arm := part_donor.arm_left
	donor_arm.get_parent().remove_child(donor_arm)

	# Assign and attach
	arm_left = donor_arm
	add_child(arm_left)
	arm_left.owner = self
	arm_left.skeleton = get_path()

	# Restore original position
	arm_left.global_transform = original_global_transform
