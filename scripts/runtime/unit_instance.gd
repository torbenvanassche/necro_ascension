class_name UnitInstance extends Node3D

var creatures: Array[CreatureInstance];
var resource: UnitResource;

@export var distance: float = 0.25;
@export var rotation_increment: float = PI / 2;

func _init(data: UnitResource) -> void:
	resource = data;
	create_creatures()
	
func create_creatures() -> void:
	for c in resource.creatures:
		var creature_instance: CreatureInstance = c.creature.instantiate();
		creatures.append(creature_instance);
		add_child(creature_instance);
		creature_instance.setup(c, Helpers.calculate_position(Manager.instance.unit_controller.creature_count, distance, rotation_increment))
		Manager.instance.unit_controller.creature_count += 1;
