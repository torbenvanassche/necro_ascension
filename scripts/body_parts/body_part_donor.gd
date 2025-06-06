class_name BodyPartDonor extends Node3D

func get_part(part_name: String) -> MeshInstance3D:
	return self.get_node("Rig/Skeleton3D/%s" % part_name);
