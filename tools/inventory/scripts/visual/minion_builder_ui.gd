extends Control

@export var part_container: Control;

@export var ui_element: PackedScene
@export var slot_size: int = 50
@export var button_fields: Array[String]

func _ready() -> void:
	if button_fields.is_empty():
		return

	for i in button_fields.size():
		var part: Control = ui_element.instantiate()
		(part as ContentSlotUI).contentSlot = ContentSlot.new();
		part.custom_minimum_size = Vector2(slot_size, slot_size)
		part_container.add_child(part)
