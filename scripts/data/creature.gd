class_name CreatureResource extends ValidatedResource

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

func validate() -> bool:
	is_valid = (resource_name != "") && (translation_key != "") && (creature != null) && (role != Role.NONE);
	return is_valid;
