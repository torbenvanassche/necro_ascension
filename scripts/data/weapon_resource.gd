class_name WeaponResource extends ItemResource

enum Type {
	INVALID,
	SWORD,
	STAFF
}

@export var weapon_type: Type = Type.INVALID;
@export var damage: float = 1.0;
@export var attack_speed: float = 1.0;

@export_group("Instantiation Parameters")
@export var marker_name: String;
@export var weapon_scene: PackedScene;
@export var weapon_position: Vector3 = Vector3.ZERO
@export var weapon_rotation: Vector3 = Vector3.ZERO


func calculate_damage() -> float:
	return damage;
	
func apply(instance: Node3D) -> void:
	instance.position = weapon_position;
	instance.rotation = weapon_rotation * deg_to_rad(1.0);
