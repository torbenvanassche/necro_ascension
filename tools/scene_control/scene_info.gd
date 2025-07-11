class_name SceneInfo
extends Resource

enum Type {
	LEVEL,
	BODY_PART,
	UI
}

@export var id:String
@export_file var packed_scene: String;
@export var type: Type;
var node: Node;

@warning_ignore("unused_signal") #false positive
signal cached(scene_info: SceneInfo);

var is_cached: bool = false;
var is_queued: bool = false;

func release() -> void:
	SceneManager.instance.scene_cache.remove(self);
	is_cached = false;
	
func get_instance() -> Node:
	if not node:
		if is_cached:
			node = ResourceLoader.load_threaded_get(packed_scene).instantiate();
			cached.emit(self);
		else:
			SceneManager.instance.get_or_create_scene(id)
	return node;
	
func try_call(c: Callable) -> void:
	if is_cached:
		c.call(self);
	elif not cached.is_connected(c):
		cached.connect(c, CONNECT_ONE_SHOT);
			
	if not is_queued && not is_cached:
		SceneManager.instance.get_or_create_scene(id);
		try_call(c)
		

func remove() -> void:
	node.get_parent().remove_child(node);
