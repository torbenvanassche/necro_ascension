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
@export var custom_properties: Dictionary = {};
@export var creature: PackedScene = null;

func validate() -> bool:
	set_name(resource_path.get_file().get_basename())
	is_valid = (resource_name != "") && (translation_key != "") && (creature != null) && (role != Role.NONE);
	return is_valid;
