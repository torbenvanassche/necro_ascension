extends Node

var active_units: Array[UnitInstance];

func add_unit(data: UnitResource) -> void:
	var unit: UnitInstance = UnitInstance.new(data)
	
func _ready() -> void:
	_defer_ready.call_deferred();

func _defer_ready() -> void:
	add_unit(Manager.instance.resource_manager.get_unit("single_ghoul"))
	
