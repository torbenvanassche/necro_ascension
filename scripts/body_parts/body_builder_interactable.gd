extends Interactable

@export var scene_info: SceneInfo;

func on_interact() -> void:
	scene_info.try_call(_on_cached)
	
func _on_cached(sI: SceneInfo) -> void:
	SceneManager.instance.add(sI)
