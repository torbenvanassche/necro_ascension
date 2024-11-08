class_name UnitController extends Node

var active_units: Array[UnitInstance];
var creature_count: int = 0;

func summon(data: UnitResource) -> void:
	var unit := UnitInstance.new(data);
	unit.name = data.resource_name + str(get_child_count());
	active_units.append(unit);
	add_child(unit);
