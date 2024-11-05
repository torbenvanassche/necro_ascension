class_name UnitInstance extends Node

var creatures: Array[CreatureInstance];
var resource: UnitResource;

func _init(data: UnitResource) -> void:
	resource = data;
