extends Node

@export var keybind_container: Node;
@onready var keybind_template = preload("res://input_prompts/action_setter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in keybind_container.get_children():
		item.queue_free();
	
	for action in InputManager.mappable_actions:
		var btn: InputDisplayer = keybind_template.instantiate();
		btn.set_label(InputManager.mappable_actions[action]);
		var events: Array[InputEvent] = InputMap.action_get_events(action);
		print(events)
		if events.size() > 0:
			var key = events[0].as_text().trim_suffix(" (Physical)").to_lower();
			btn.set_key(key);
		
		keybind_container.add_child(btn);
