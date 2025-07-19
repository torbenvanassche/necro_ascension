class_name BodyPartReceiver
extends Skeleton3D

func replace_mesh_instance(to_remove: MeshInstance3D, to_add: MeshInstance3D) -> void:
	var original_global_transform := to_remove.global_transform

	if is_instance_valid(to_remove) and to_remove.get_parent() == self:
		remove_child(to_remove)
		to_remove.queue_free()

	if is_instance_valid(to_add) and to_add.get_parent():
		to_add.get_parent().remove_child(to_add)
		
	to_add.global_transform = original_global_transform
	add_piece(to_add)

func add_piece(to_add: MeshInstance3D) -> void:
	if is_instance_valid(to_add) and to_add.get_parent():
		to_add.get_parent().remove_child(to_add)

	to_add.owner = null
	add_child(to_add)
	
	to_add.owner = self
	to_add.skeleton = get_path()
	to_add.position = Vector3.ZERO;

func add_or_replace_piece(to_add: MeshInstance3D) -> void:
	if not is_instance_valid(to_add):
		return
	
	var existing_piece := get_node_or_null(to_add.get_path())
	if existing_piece and existing_piece is MeshInstance3D:
		replace_mesh_instance(existing_piece, to_add)
	else:
		add_piece(to_add)
