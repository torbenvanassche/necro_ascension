class_name UnitResource extends ValidatedResource

@export var translated_key: String = "";
@export var custom_properties: Dictionary = {};
@export var creatures: Array[CreatureResource]

func validate() -> bool:
	is_valid = (resource_name != "") && (translated_key != "");
	return is_valid;
