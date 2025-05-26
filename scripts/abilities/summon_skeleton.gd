extends Node

var skeleton: PackedScene = preload("res://scenes/creatures/skeleton_minion.tscn");

func execute(options: Dictionary = {}) -> bool:
	var ray_result: Dictionary = Manager.instance.camera.get_ray_hit_from_screen_point();
	if ray_result != {}:
		Manager.instance.player.animation_controller.set_state_on_machine("summon");
		var skeleton_instance: Skeleton = skeleton.instantiate();
		Manager.instance.player.creature_container.add_child(skeleton_instance);
		skeleton_instance.position = ray_result.position;
		return true;
	return false;
