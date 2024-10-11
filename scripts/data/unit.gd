class_name UnitResource extends ValidatedResource

enum Role{
	NONE,
	THRALL,
	ARTILLERY,
	WARDEN,
	MONSTROSITY,
	SPECIALIST
}

@export var name: String = "";
@export var custom_properties: Dictionary = {};
@export var animations: AnimationLibrary = null;
@export var role: Role = Role.NONE;
@export var abilities: Array[AbilityResource] = [];

func validate():
	is_valid = (name != "") && (animations != null) && (role != Role.NONE);
	return is_valid;
