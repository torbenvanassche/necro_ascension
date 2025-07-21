class_name BodyPartDonor extends Node3D

var parts: Dictionary[String, MeshInstance3D];
@onready var skeleton: Skeleton3D = %GeneralSkeleton;

func _ready() -> void:
	if skeleton:
		for child in skeleton.get_children():
			if child is MeshInstance3D:
				parts.set(child.name, child);

func get_part(part_name: String) -> MeshInstance3D:
	return parts.get(part_name).duplicate();
