extends Node

var entrances: Array[Entrance];

func _ready() -> void:
	entrances.assign(Helpers.flatten_hierarchy(self, false).filter(func(n: Node) -> bool: return n is Entrance));
