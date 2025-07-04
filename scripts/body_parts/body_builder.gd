extends Interactable

func on_interact() -> void:
	SceneManager.instance.get_or_create_scene("minion_window");
