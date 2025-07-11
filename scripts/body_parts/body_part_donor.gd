class_name BodyPartDonor extends Node3D

@export var parts: Dictionary[String, MeshInstance3D];

func get_part(part_name: String) -> MeshInstance3D:
	return parts.get(part_name);
