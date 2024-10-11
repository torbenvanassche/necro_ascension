class_name AbilityResource extends ValidatedResource

@export var cooldown: float = -1;
@export var ui_sprite: Texture2D = null;
@export var ability_script: Script = null;

func validate() -> bool:
	is_valid = (cooldown != -1) && (ui_sprite != null) && (ability_script != null);
	return is_valid;
