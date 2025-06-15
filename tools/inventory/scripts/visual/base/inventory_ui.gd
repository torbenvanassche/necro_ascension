class_name InventoryUI
extends Control

@export var inventory: Inventory
@export var packed_slot: PackedScene

@onready var root: GridContainer = $CenterContainer/GridContainer

var selected_slot: ContentSlotUI

func _ready() -> void:
	root.resized.connect(_control_size, CONNECT_DEFERRED)

	if inventory:
		for element in inventory.data:
			add(element)

	await get_tree().process_frame
	_control_size()

func _control_size() -> void:
	var container_width := size.x
	var columns := maxi(root.columns, 1)
	var h_separation := root.get_theme_constant("h_separation")

	var container_size_x: int = clamp((container_width / columns) - h_separation, 15, 50)

	for e: Control in root.get_children():
		e.custom_minimum_size.x = container_size_x
		e.custom_minimum_size.y = container_size_x

func add(content: ContentSlot) -> ContentSlotUI:
	var container: ContentSlotUI = packed_slot.instantiate() as ContentSlotUI
	container.button_up.connect(_set_selected.bind(container))
	container.set_content(content)
	root.add_child(container)
	return container

func _set_selected(slot: ContentSlotUI) -> void:
	if !slot or (selected_slot != slot and selected_slot):
		selected_slot.button_pressed = false
		selected_slot = null

	var redraw: bool = selected_slot == slot
	if redraw or slot:
		slot.button_pressed = false
		selected_slot = null
	else:
		selected_slot = slot
