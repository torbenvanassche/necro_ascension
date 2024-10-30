class_name CreatureResource extends ValidatedResource

@export var name: String = "";
@export var custom_properties: Dictionary = {};
@export var animations: AnimationLibrary = null;
@export var abilities: Array[AbilityResource] = [];

func validate() -> bool:
	is_valid = (name != "") && (animations != null);
	return is_valid;
