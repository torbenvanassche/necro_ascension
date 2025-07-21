class_name BodyBuilderInteractable extends Interactable

@export var scene_info: SceneInfo;
@onready var location: Node3D = $minion_constructor;
var build_in_progress: Skeleton;

func on_interact() -> void:
	scene_info.queue(_on_cached)
	
func _on_cached(sI: SceneInfo) -> void:
	SceneManager.instance.add(sI)
	
func set_buildable(data: Skeleton) -> void:
	location.add_child(data);
	build_in_progress = data;
