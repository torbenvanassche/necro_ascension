class_name SceneManager
extends Node

@export var scenes: Array[SceneInfo];
var scene_stack: Array[SceneInfo] = [];


@export var initial_scene: SceneInfo;
@export var ui_root: CanvasLayer;
static var instance: SceneManager;
var game_loaded_timestamp: Dictionary;

signal scene_entered(scene: Node)
signal scene_exited(scene: Node)

func _ready() -> void:
	SceneManager.instance = self;
	set_active_scene(initial_scene.id, SceneConfig.new(true, true, true))

var active_scene: Node:
	get: return active_scene;
	set(new_scene):
		if new_scene == null:
			return;
		if active_scene != null:
			scene_exited.emit(active_scene);
			if active_scene.has_method("on_disable"):
				active_scene.on_disable();
		active_scene = new_scene;
		active_scene.visible = true;
		scene_entered.emit(active_scene);
			
func get_or_create_scene(scene_name: String) -> Node:	
	var filtered: Array = scenes.filter(func(scene: SceneInfo) -> bool: return scene != null && scene.id == scene_name);
	if filtered.size() == 0:
		Debug.err(scene_name + " was not found, unable to instantiate!")
	elif filtered.size() == 1:
		var scene_info: SceneInfo = filtered[0];
		if is_instance_valid(scene_info.node):
			return scene_info.node;
		else:
			var node: Node = scene_info.packed_scene.instantiate();
			if scene_info.is_ui:
				ui_root.add_child(node)
			else:
				add_child(node)
			scene_info.node = node
			return node;
	else:
		Debug.err(scene_name + " was invalid.")
		return null;
	return null;
		
func node_to_info(node: Node) -> SceneInfo:
	var filtered: Array = scenes.filter(func(x: SceneInfo) -> bool: return x.node == node);
	if filtered.size() == 1:
		return filtered[0];
	Debug.err("Could not find " + node.name + " in scenes.")
	return null
	
func get_scene_info(id: String) -> SceneInfo:
	var filtered: Array  = scenes.filter(func(x: SceneInfo) -> bool: return x.id == id);
	if filtered.size() == 1:
		return filtered[0];
	Debug.err("Could not find " + id + " in scenes.")
	return null;

func set_scene_reference(id: String, target: Node) -> void:
	get_scene_info(id).node = target;
		
func set_active_scene(scene_name: String, config: SceneConfig, set_on_stack: bool = true) -> Node:
	var previous_scene_info: SceneInfo = null;
	if active_scene != null:
		previous_scene_info = node_to_info(active_scene);
		if previous_scene_info.id == scene_name:
			return; 
		if config.disable_processing:
			active_scene.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		if config.hide_current:
			active_scene.visible = false;
		if config.free_current: 
			previous_scene_info.node.queue_free() 
	active_scene = get_or_create_scene(scene_name)
	if active_scene != null:
		if set_on_stack:
			scene_stack.append(node_to_info(active_scene))
		if active_scene.has_method("on_enable"):
			active_scene.on_enable(config.custom_parameters)
			active_scene.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	return active_scene;
	
func reset_to_scene(scene_name: String) -> void:
	for sceneInfo in scenes:
		if sceneInfo.id != scene_name && sceneInfo.node != null:
			sceneInfo.node.queue_free()
	set_active_scene(scene_name, SceneConfig.new())
		
func to_previous_scene(hide_current: bool = false, stop_processing_current: bool = false, remove_current: bool = false) -> void:
	if scene_stack.size() != 0:
		scene_stack.pop_back();
		set_active_scene(scene_stack[scene_stack.size() - 1].id, SceneConfig.new(hide_current, stop_processing_current, remove_current), false);
		
func ui_is_open(exceptions: Array[String] = ["pause"]) -> bool:
	return get_children().all(func(x: Node) -> bool: return node_to_info(x).is_ui && x.visible && !exceptions.has(node_to_info(x).id));
	
func remove_ui() -> void:
	for scene_info in scenes:
		if scene_info.is_ui && scene_info.node != null:
			scene_info.node.visible = false;
			
func is_active(scene_name: String) -> bool:
	for sceneInfo in scenes:
		if sceneInfo.id != scene_name && sceneInfo.node != null && sceneInfo.node.visible == true:
			return true;
	return false;
