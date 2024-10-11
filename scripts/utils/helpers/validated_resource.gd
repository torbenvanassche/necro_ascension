class_name ValidatedResource extends Resource

var is_valid: bool = false;

func validate() -> bool:
	assert("Validation function for %s is not defined." % self.resource_name)
	return is_valid;
