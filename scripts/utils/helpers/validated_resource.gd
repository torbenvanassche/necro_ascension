class_name ValidatedResource extends Resource

var is_valid: bool = false;

func _setup() -> void:
	set_name(resource_path.get_file().get_basename())

func validate() -> bool:
	assert("Validation function for %s is not defined." % self.resource_name)
	return is_valid;
