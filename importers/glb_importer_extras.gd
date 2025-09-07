@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Object:
	var source_path := get_source_file()

	var gltf_doc := GLTFDocument.new()
	var state := GLTFState.new()
	var err := gltf_doc.append_from_file(source_path, state)
	if err != OK:
		push_error("Failed to load GLB: %s" % source_path)
		return scene

	if state.json.has("extras"):
		var extras: Dictionary = state.json["extras"]
		print("GLB extras:", extras)

	return scene
