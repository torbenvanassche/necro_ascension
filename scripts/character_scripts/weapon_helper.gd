extends Marker3D

func toggle_collider(b: bool) -> void:
	var target: CollisionShape3D = get_node("weapon_mesh/Area3D/CollisionShape3D");
	target.disabled = b;
