class_name SceneCache extends Node

var cached_scenes: Array[SceneInfo] = [];
var loading_queue: Array[SceneInfo] = [];

func _init():
	var timer = Timer.new();
	timer.timeout.connect(_check_progress)
	timer.wait_time = 0.1;
	
	Manager.instance.orphan_timers.add_child(timer)
	timer.start();

func queue(scene_info: SceneInfo):
	loading_queue.append(scene_info);
	var error = ResourceLoader.load_threaded_request(scene_info.packed_scene.resource_path, type_string(typeof(PackedScene)))
	if error:
		loading_queue.erase(scene_info)
		Debug.err(error)

func _check_progress():
	for loading in loading_queue:
		if ResourceLoader.load_threaded_get_status(loading.packed_scene.resource_path) == ResourceLoader.THREAD_LOAD_LOADED:
			loading.node = ResourceLoader.load_threaded_get(loading.packed_scene.resource_path).instantiate();
			cached_scenes.append(loading)
			loading_queue.erase(loading)
			loading.cached.emit(loading);

func get_from_cache(scene_info: SceneInfo) -> Node:
	if cached_scenes.has(scene_info):
		return cached_scenes[cached_scenes.find(scene_info)].node;
	else:
		queue(scene_info)
		return null;
		
func is_cached(scene_info: SceneInfo):
	if loading_queue.has(scene_info) || cached_scenes.has(scene_info):
		return ResourceLoader.load_threaded_get_status(scene_info.packed_scene.resource_path)
	else:
		return -1;
