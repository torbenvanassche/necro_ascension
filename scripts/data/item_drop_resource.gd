class_name ItemDropPoolResource extends Resource

@export var drop_pool: Array[ItemResource];  

func generate_loot() -> ItemResource:
	return drop_pool.pick_random()
