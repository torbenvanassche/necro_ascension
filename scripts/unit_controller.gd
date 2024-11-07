class_name UnitController extends Node

var active_units: Array[UnitInstance];
var creature_count: int = 0;

func summon(data: UnitResource) -> void:
	var unit := UnitInstance.new(data);
	unit.name = data.resource_name + str(get_child_count());
	active_units.append(unit);
	add_child(unit);
	
func _ready() -> void:
	if not Manager.instance.resource_manager:
		setup.call_deferred();
	else:
		setup();
	
func setup() -> void:
	summon(Manager.instance.resource_manager.get_unit("single_ghoul"))
	summon(Manager.instance.resource_manager.get_unit("single_ghoul"))
	summon(Manager.instance.resource_manager.get_unit("single_ghoul"))
	summon(Manager.instance.resource_manager.get_unit("single_ghoul"))
