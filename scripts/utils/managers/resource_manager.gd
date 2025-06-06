class_name ResourceManager extends Node

@export var creatures: Array[CreatureResource];
@export var items: Array[ItemResource];

@export var packed_donors: Dictionary[String, PackedScene];
var donors: Dictionary[String, BodyPartDonor];
		
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

func get_donor(donor_name: String) -> BodyPartDonor:
	if donors.has(donor_name):
		return donors[donor_name];
	elif packed_donors.has(donor_name):
		donors.set(donor_name, packed_donors[donor_name].instantiate())
		return donors[donor_name];
	Debug.err("%s was not found on BodyPartManager" % donor_name)
	return null;
