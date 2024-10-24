class_name FillBar
extends ProgressBar

@export var max_fill: float = 100;
@export var current_fill: float = 100;

signal is_depleted()

func set_data(curr_health: float = max_fill) -> void:
	current_fill = curr_health
	
	if has_theme_stylebox("background"):
		var value_padding_left = get_theme_stylebox("background").get("border_width_left") * 2;
		var value_padding_right = get_theme_stylebox("background").get("border_width_right") * 2;
		max_value = max_fill + value_padding_left + value_padding_right;
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE;
	value = current_fill;
	visible = true;

func decrease_health(amount: float) -> void:
	current_fill -= amount;
	value = current_fill;
	
	if current_fill <= 0:
		is_depleted.emit()
		
func is_empty() -> bool:
	return current_fill > 0;
