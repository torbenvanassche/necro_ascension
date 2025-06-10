extends Interactable

var part_overrides: Dictionary[String, MeshInstance3D];

func on_interact(btn_index: int) -> void:
	super(btn_index);
