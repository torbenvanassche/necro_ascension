class_name UnitResource extends ValidatedResource

@export var creatures: Array[CreatureResource]

func validate() -> bool:
	_setup();
	is_valid = (resource_name != "");
	return is_valid;
