extends Node

var skeleton: CreatureResource;

func execute(_options: Dictionary = {}) -> bool:
	var ray_result: Dictionary = Manager.instance.camera.get_ray_hit_from_screen_point();
	if ray_result != {}:
		Manager.instance.player.animation_controller.set_state_on_machine("summon");
		var skeleton_instance: Skeleton = skeleton.creature.instantiate();
		skeleton_instance.data = skeleton;
		if not Manager.instance.player.creature_controller.add_creature(skeleton_instance):
			return false;
		skeleton_instance.position = ray_result.position;
		Manager.instance.player.do_processing = false;
		return true;
	return false;
