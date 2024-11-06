class_name UnitInstance extends Node3D

var creatures: Array[CreatureInstance];
var resource: UnitResource;

func _init(data: UnitResource) -> void:
	resource = data;
	create_creatures()
	
func create_creatures() -> void:
	for c in resource.creatures:
		var creature_instance: CreatureInstance = c.creature.instantiate();
		creatures.append(creature_instance)
		creature_instance.data = c;
		add_child(creature_instance);
