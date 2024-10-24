class_name AbilityRuntime extends Node

var ui_element: TextureRect;
var data: AbilityResource;

var cooldown_timer: Timer = null;
var _action: Node;

signal executed();

func _init(resource: AbilityResource = null) -> void:
	if resource != null:
		data = resource.duplicate();
		if resource.cooldown != 0:
			cooldown_timer = Timer.new();
			cooldown_timer.wait_time = resource.cooldown;
			cooldown_timer.one_shot = true;
			self.add_child(cooldown_timer)
		_action = Node.new();
		_action.set_script(data.ability_script);
		if not _action.has_method("execute"):
			assert("%s is missing an execute function on ability: " % resource.resource_name)
			
func execute(options: Dictionary = {}) -> void:
	if not cooldown_timer.is_stopped():
		return;
	
	_action.execute(options);
	executed.emit();
	cooldown_timer.start()
