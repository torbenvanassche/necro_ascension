@tool
class_name ResourceManager extends Node

@export_tool_button("Get data") var get_data_action: Callable = get_data
func get_data() -> void:
	items.clear();
	creatures.clear();
	scenes.clear();
	
	Helpers.recursive_list("res://resources/items", items, ".tres")
	Helpers.recursive_list("res://resources/creatures", creatures, ".tres")
	Helpers.recursive_list("res://resources/scene_info", scenes, ".tres")
	notify_property_list_changed();

@export var creatures: Array[CreatureResource];
@export var items: Array[ItemResource];
@export var scenes: Array[SceneInfo];

@export var packed_donors: Dictionary[String, PackedScene];
var donors: Dictionary[String, Node3D];
		
func get_creature(creature_name: String) -> CreatureResource:
	var valid_creatures := creatures.filter(func(x: CreatureResource) -> bool: return x.unique_id == creature_name);
	if valid_creatures.size() == 1:
		return valid_creatures[0];
	else:
		return null;
		
func get_item(key: String) -> ItemResource:
	var valid_items := items.filter(func(x: ItemResource) -> bool: return x.unique_id == key);
	if valid_items.size() == 1:
		return valid_items[0];
	elif valid_items.size() == 0:
		Debug.err("No item was found with key: %s" % key)
	else:
		Debug.err("Multiple items found with key: %s" % key)
	return null;
	
func get_body_parts_by_scene_info(scene_info: SceneInfo, type: BodyPart.Type = BodyPart.Type.UNDEFINED) -> Array[BodyPart]:
	var returnValue: Array[BodyPart];
	returnValue.assign(items.filter(func(x: ItemResource) -> bool: return x is BodyPart && x.scene_info == scene_info));
	if type != BodyPart.Type.UNDEFINED:
		returnValue = returnValue.filter(func(x: BodyPart) -> bool: return x.type == type);
	return returnValue;

func get_donor(donor_name: String) -> Node3D:
	if donors.has(donor_name):
		return donors[donor_name];
	elif packed_donors.has(donor_name):
		donors.set(donor_name, packed_donors[donor_name].instantiate())
		return donors[donor_name];
	Debug.err("%s was not found on BodyPartManager" % donor_name)
	return null;
