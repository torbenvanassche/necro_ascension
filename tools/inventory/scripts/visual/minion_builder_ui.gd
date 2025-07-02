extends Control

@export var body_slot_container: Control;

@export var ui_element: PackedScene
@export var slot_size: int = 50
@export var body_parts: Array[ContentSlotUI]

func _ready() -> void:
	for body_slot in body_slot_container.get_children():
		body_parts.append(body_slot);
