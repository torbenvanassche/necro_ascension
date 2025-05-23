class_name ItemSelectorResource extends Resource

@export var drop_pool: Array[Resource];  

func generate_item() -> Resource:
	return drop_pool.pick_random()

func _validate_property(_property: Dictionary) -> void:
	if drop_pool.size() != 0 && drop_pool.all(func(x: Resource) -> bool: return x.type == drop_pool[0].type):
		Debug.err("one or more elements in the array have different type, please make sure they are the same.")
