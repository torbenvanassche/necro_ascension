extends Node

var skeleton: PackedScene = preload("res://scenes/creatures/skeleton_minion.tscn");

func execute(options: Dictionary = {}) -> void:
	var ray_result: Dictionary = Manager.instance.camera.get_ray_hit_from_screen_point();
	Manager.instance.player.animation_controller.one_shot("summon");
	if ray_result != {}:
		var skeleton_instance: Skeleton = skeleton.instantiate();	
		Manager.instance.player.creature_container.add_child(skeleton_instance);
		skeleton_instance.position = ray_result.position;
