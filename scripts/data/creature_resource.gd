class_name CreatureResource extends Resource

enum Role{
	NONE,
	THRALL,
	ARTILLERY,
	WARDEN,
	MONSTROSITY,
	SPECIALIST
}

@export var translation_key: String = "";
@export var role: Role = Role.NONE;
@export var creature: PackedScene = null;
@export var move_speed: float = 1;
@export var health: float = 1;
