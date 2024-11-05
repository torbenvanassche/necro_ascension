@tool
class_name ResourceManager extends Node

@export var populate: bool:
	set(value):
		creatures.clear();
		units.clear();
		populate = value;
		
		#creatures
		var creature_paths := FileUtils.get_resource_paths("resources/creatures");
		for path in creature_paths:
			creatures.append(ResourceLoader.load("res://" + path))
		
		#units
		var unit_paths := FileUtils.get_resource_paths("resources/units");
		for path in unit_paths:
			units.append(ResourceLoader.load("res://" + path))
		notify_property_list_changed()

@export var creatures: Array[CreatureResource];
@export var units: Array[UnitResource];

func get_unit(unit_name: String) -> UnitResource:
	var valid_units := units.filter(func(x: UnitResource) -> bool: return x.get_name() == unit_name);
	if valid_units.size() == 1:
		return valid_units[0];
	else:
		return null;
		
func get_creature(unit_name: String) -> CreatureResource:
	var valid_creature := creatures.filter(func(x: CreatureResource) -> bool: return x.get_name() == unit_name);
	if valid_creature.size() == 1:
		return valid_creature[0];
	else:
		return null;
		
func _ready() -> void:
	for unit in units:
		unit.validate();
		
	for creature in creatures:
		creature.validate();
