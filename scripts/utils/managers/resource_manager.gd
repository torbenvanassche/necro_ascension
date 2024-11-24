@tool
class_name ResourceManager extends Node

@export var populate: bool:
	set(value):
		creatures.clear();
		units.clear();
		items.clear();
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
			
		#items
		var item_paths := FileUtils.get_resource_paths("resources/items");
		for path in item_paths:
			var r := ResourceLoader.load("res://" + path);
			items.append(r)
		notify_property_list_changed()

@export var creatures: Array[CreatureResource];
@export var units: Array[UnitResource];
@export var items: Array[ItemResource];

func get_unit(unit_name: String) -> UnitResource:
	var valid_units := units.filter(func(x: UnitResource) -> bool: return x.resource_name == unit_name);
	if valid_units.size() == 1:
		return valid_units[0]; 
	else:
		Debug.err("Tried to fetch a unit that doesn't exist: %s" % unit_name)
		return null;
		
func get_creature(creature_name: String) -> CreatureResource:
	var valid_creatures := creatures.filter(func(x: CreatureResource) -> bool: return x.resource_name == creature_name);
	if valid_creatures.size() == 1:
		return valid_creatures[0];
	else:
		return null;
		
func get_item(item_name: String) -> ItemResource:
	var valid_items := items.filter(func(x: ItemResource) -> bool: return x.resource_name == item_name);
	if valid_items.size() == 1:
		return valid_items[0];
	else:
		return null;
		
func _ready() -> void:
	for c in creatures:
		c.validate()
		
	for u in units:
		u.validate();
		
	for i in items:
		i.validate();
