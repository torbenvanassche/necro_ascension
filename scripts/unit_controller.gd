extends Node

var active_units: Array[UnitInstance];

func add_unit(data: UnitResource) -> void:
	active_units.append(UnitInstance.new(data));
	
func _ready() -> void:
	if not Manager.instance.resource_manager:
		setup.call_deferred();
	else:
		setup();
	
func setup() -> void:
	add_unit(Manager.instance.resource_manager.get_unit("single_ghoul"))
