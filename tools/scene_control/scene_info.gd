class_name SceneInfo
extends Resource

enum Type {
	LEVEL,
	BODY_PART
}

@export var id:String
@export_file var packed_scene: String;
@export var type: Type;
@export var is_ui: bool = false;
var node: Node;

@warning_ignore("unused_signal") #false positive
signal cached(scene_info: SceneInfo);

func release() -> void:
	SceneManager.instance.scene_cache.remove(self);

func remove() -> void:
	node.get_parent().remove_child(node);
