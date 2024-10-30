class_name UnitResource extends ValidatedResource

enum Role{
	NONE,
	THRALL,
	ARTILLERY,
	WARDEN,
	MONSTROSITY,
	SPECIALIST
}

@export var role: Role = Role.NONE;
@export var name: String = "";
@export var custom_properties: Dictionary = {};
@export var creatures: Array[CreatureResource]

func validate() -> bool:
	is_valid = (name != "") && (role != Role.NONE);
	return is_valid;
