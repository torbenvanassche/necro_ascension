class_name BodyPartDonor extends Node3D

@export var meshes: Dictionary[String, MeshInstance3D];

func get_part(part_name: String) -> MeshInstance3D:
	if meshes.has(part_name):
		return meshes[part_name];
	Debug.err("%s was not found on BodyPartDonor" % part_name)
	return null;
