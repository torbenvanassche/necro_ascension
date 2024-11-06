class_name UnitInstance extends Node

var creatures: Array[CreatureInstance];
var resource: UnitResource;

func _init(data: UnitResource) -> void:
	resource = data;
	
func create_creatures() -> void:
	for c in resource.creatures:
		var creature_instance := c.creature.instantiate();
		creatures.append(creature_instance)
