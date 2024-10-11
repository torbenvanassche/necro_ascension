class_name InputMapper extends Node

static func get_key(key: String) -> String:
	if InputMap.has_action(key):
		var events = InputMap.action_get_events(key)
		print((events[0] as InputEventKey).as_text_physical_keycode().to_lower())
		return (events[0] as InputEventKey).as_text_physical_keycode().to_lower();
	return ""
