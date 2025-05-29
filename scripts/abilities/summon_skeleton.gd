extends Node

var skeleton: CreatureResource = preload("res://resources/creatures/skeleton_minion.tres");

func execute(options: Dictionary = {}) -> bool:
	var ray_result: Dictionary = Manager.instance.camera.get_ray_hit_from_screen_point();
	if ray_result != {}:
		Manager.instance.player.animation_controller.set_state_on_machine("summon");
		var skeleton_instance: Skeleton = skeleton.creature.instantiate();
		skeleton_instance.data = skeleton;
		Manager.instance.player.creature_controller.add_unit(skeleton_instance);
		skeleton_instance.position = ray_result.position;
		return true;
	return false;
