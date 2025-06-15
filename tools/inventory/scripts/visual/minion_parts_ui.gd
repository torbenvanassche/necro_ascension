extends InventoryUI

func _ready() -> void:
	if !Manager.instance.player.is_node_ready():
		Manager.instance.player.ready.connect(_on_player_ready)
	else:
		_on_player_ready();
	
func _on_player_ready() -> void:
	inventory = Manager.instance.player.body_part_inventory;
	super._ready();
	
	_control_size()
