class_name CreatureController extends Node

signal creature_removed(c: CreatureInstance);

var positions: Array[ManagedPosition] = [ManagedPosition.new(Vector3.FORWARD), ManagedPosition.new(Vector3.BACK), ManagedPosition.new(Vector3.LEFT), ManagedPosition.new(Vector3.RIGHT)];

var active_creatures: Array[CreatureInstance];

func add_creature(c: CreatureInstance) -> bool:
	if get_available_position(false):
		add_child(c);
		active_creatures.append(c);
		c.setup(c.data, get_available_position(true));
		return true;
	else:
		c.queue_free();
	return false;

func remove_creature(c: CreatureInstance) -> void:
	if active_creatures.size() > 0:
		c.man_pos.is_open = true;
		active_creatures.erase(c);
		creature_removed.emit(c)
		if not c.is_queued_for_deletion():
			c.queue_free()
			
func get_available_position(set_as_used: bool) -> ManagedPosition:
	var selected: ManagedPosition = positions.filter(func(x: ManagedPosition) -> bool: return x.is_open).pick_random();
	if set_as_used:
		selected.is_open = true;
	return selected;
