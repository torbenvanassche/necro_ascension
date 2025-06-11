extends Control

@onready var part_container: Control = $Panel/VBoxContainer/PartContainer

@export var ui_element: PackedScene
@export_range(0, 360) var angle_offset: int;
@export var slot_size: int = 50
@export var button_fields: Array[String]

func _ready() -> void:
	if button_fields.is_empty():
		return

	var center := part_container.size / 2

	for i in button_fields.size():
		var part: Control = ui_element.instantiate()
		(part.get_node("slot") as ContentSlotUI).contentSlot = ContentSlot.new();
		(part.get_node("Label") as Label).text = button_fields[i];
		part.custom_minimum_size = Vector2(slot_size, slot_size)
		part_container.add_child(part)

		if i == 0:
			part.position = center - Vector2(slot_size, slot_size) / 2
		else:
			var angle := (TAU / (button_fields.size() - 1)) * (i - 1) + deg_to_rad(angle_offset)
			var offset := Vector2(cos(angle), sin(angle)) * slot_size * 2
			part.position = center + offset - Vector2(slot_size, slot_size) / 2
