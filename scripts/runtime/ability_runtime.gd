class_name AbilityRuntime extends Node

var ui_element: TextureRect;
var data: AbilityResource;

var cooldown_timer: Timer = null;
var _action: Node;

func _init(resource: AbilityResource = null):
	if resource != null:
		data = resource.duplicate();
		if resource.cooldown != 0:
			cooldown_timer = Timer.new();
			cooldown_timer.wait_time = resource.cooldown;
			self.add_child(cooldown_timer)
		_action = Node.new();
		_action.set_script(data.ability_script);
		if not _action.has_method("execute"):
			assert("%s is missing an execute function on ability: " % resource.resource_name)
			
func execute(options: Dictionary = {}):
	_action.execute(options);
