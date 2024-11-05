class_name UnitResource extends ValidatedResource

@export var creatures: Array[CreatureResource]

func validate() -> bool:
	set_name(resource_path.get_file().get_basename())
	is_valid = (resource_name != "");
	return is_valid;
