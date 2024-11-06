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
			var r := ResourceLoader.load("res://" + path);
			creatures.append(r)
		
		#units
		var unit_paths := FileUtils.get_resource_paths("resources/units");
		for path in unit_paths:
			var r := ResourceLoader.load("res://" + path);
			units.append(r)
		notify_property_list_changed()

@export var creatures: Array[CreatureResource];
@export var units: Array[UnitResource];

func get_unit(unit_name: String) -> UnitResource:
	var valid_units := units.filter(func(x: UnitResource) -> bool: return x.resource_path.get_file().get_basename() == unit_name);
	if valid_units.size() == 1:
		return valid_units[0];
	else:
		Debug.err("Tried to fetch a unit that doesn't exist: %s" % unit_name)
		return null;
		
func get_creature(unit_name: String) -> CreatureResource:
	var valid_creature := creatures.filter(func(x: CreatureResource) -> bool: return x.resource_path.get_file().get_basename() == unit_name);
	if valid_creature.size() == 1:
		return valid_creature[0];
	else:
		return null;
