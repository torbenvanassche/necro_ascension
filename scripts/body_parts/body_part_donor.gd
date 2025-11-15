class_name BodyPartDonor
extends Node3D

var parts: Dictionary[String, BodyPart] = {}
var skeleton: Skeleton3D
var setup_called: bool = false

func _ready() -> void:
	_setup()

func _setup() -> void:
	if setup_called:
		return

	skeleton = get_node_or_null("Armature/GeneralSkeleton")
	if not skeleton:
		return

	var sI := SceneManager.instance.get_scene_info_from_instance(self)

	for child: MeshInstance3D in skeleton.get_children().filter(func(x: Node) -> bool: return x is MeshInstance3D):
		var part_type: BodyPart.Type
		match child.name:
			"armleft":
				part_type = BodyPart.Type.OFF_HAND
			"armright":
				part_type = BodyPart.Type.MAIN_HAND
			"body":
				part_type = BodyPart.Type.BODY
			"head":
				part_type = BodyPart.Type.HEAD
			"legs":
				part_type = BodyPart.Type.LEGS
			_:
				continue

		var found_parts := Manager.instance.resource_manager.get_body_parts_by_scene_info(sI, part_type)
		if found_parts.size() == 1:
			parts[child.name] = found_parts[0]
			found_parts[0].runtime_mesh = child;
		elif found_parts.size() == 0:
			Debug.err("No parts were mapped on %s for %s" % [self.name, child.name])
		else:
			Debug.err("Multiple parts were found on %s for %s" % [self.name, child.name])
	setup_called = true

func get_part(part_name: String) -> BodyPart:
	_setup()
	return parts.get(part_name)

func get_part_mesh(part_name: String) -> MeshInstance3D:
	var part := get_part(part_name)
	if part:
		return part.runtime_mesh.duplicate()
	return null
