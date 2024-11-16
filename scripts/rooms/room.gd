extends Node

var entrances: Array[Entrance];

func _ready() -> void:
	var all_children: Array[Node] = Helpers.flatten_hierarchy(self, false);
	entrances = all_children.filter(func(n: Node) -> bool: return n is Entrance)
