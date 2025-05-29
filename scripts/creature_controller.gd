class_name CreatureController extends Node

var active_units: Array[CreatureInstance];
var creature_count: int = 0;
var creature_parent: Node;

func _init(container: Node) -> void:
	creature_parent = container;

func add_unit(c: CreatureInstance) -> void:	
	creature_parent.add_child(c);
	active_units.append(c);
	creature_count += 1;
