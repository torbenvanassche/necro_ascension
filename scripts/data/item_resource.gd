class_name ItemResource extends ValidatedResource

@export var translation_key_name: String;
@export var translation_key_description: String;

func validate() -> bool:
	_setup();
	is_valid = (resource_name != "");
	return is_valid;
