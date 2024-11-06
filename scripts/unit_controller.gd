extends Node

var active_units: Array[UnitInstance];
var angle_increment: float = PI / 2;

func add_unit(data: UnitResource) -> void:
	var unit := UnitInstance.new(data);
	unit.name = data.resource_name + str(get_child_count());
	unit.position = calculate_position(get_child_count(), 1);
	active_units.append(unit);
	add_child(unit);
	
func _ready() -> void:
	if not Manager.instance.resource_manager:
		setup.call_deferred();
	else:
		setup();
	
func setup() -> void:
	add_unit(Manager.instance.resource_manager.get_unit("single_ghoul"))
	add_unit(Manager.instance.resource_manager.get_unit("single_ghoul"))
	add_unit(Manager.instance.resource_manager.get_unit("single_ghoul"))
	add_unit(Manager.instance.resource_manager.get_unit("single_ghoul"))
	
func calculate_position(index: int, radius: float) -> Vector3:
	var total_angle := index * angle_increment;
	return Vector3(radius * cos(total_angle), 0, radius * sin(total_angle));
