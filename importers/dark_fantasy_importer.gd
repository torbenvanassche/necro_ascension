@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Node:
	iterate(scene)
	return scene

func iterate(node: Node) -> void:
	if node != null && node is MeshInstance3D:
		apply_material(node as MeshInstance3D)
		
	for child in node.get_children():
		iterate(child)

func apply_material(mI: MeshInstance3D) -> void:
	var mesh := mI.mesh;
	var surfaces := mesh.get_surface_count();
	for index in surfaces:
		var mat := mesh.surface_get_material(index);
		print(mat.resource_name)
		if mat == null:
			continue;
		else:
			mesh.surface_set_material(index, load("res://imported_data/materials/synty_dark_fantasy.tres"))
