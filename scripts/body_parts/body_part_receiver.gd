class_name BodyPartReceiver
extends Skeleton3D

@export var donor: PackedScene

func replace_mesh_instance(to_remove: MeshInstance3D, to_add: MeshInstance3D) -> void:
	var original_global_transform := to_remove.global_transform

	if is_instance_valid(to_remove) and to_remove.get_parent() == self:
		remove_child(to_remove)
		to_remove.queue_free()

	if is_instance_valid(to_add) and to_add.get_parent():
		to_add.get_parent().remove_child(to_add)

	to_add.owner = null;
	add_child(to_add)
	to_add.owner = self
	to_add.skeleton = get_path()

	to_add.global_transform = original_global_transform

func add_piece(to_add: MeshInstance3D) -> void:
	if is_instance_valid(to_add) and to_add.get_parent():
		to_add.get_parent().remove_child(to_add)

	to_add.owner = null;
	add_child(to_add)
	to_add.owner = self
	to_add.skeleton = get_path()
