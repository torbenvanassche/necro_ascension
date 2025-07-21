class_name ObjectPool extends Node3D

var pool: Array[SceneInfo];

func add_scene(scene_info: SceneInfo) -> void:
	if not pool.has(scene_info):
		add_child(scene_info.get_instance());
		pool.append(scene_info);
		
func has_scene(scene_info: SceneInfo) -> bool:
	return pool.has(scene_info);
