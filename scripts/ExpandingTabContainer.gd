@tool
extends VBoxContainer

class_name ExpandingTabContainer

@export var btngroup : ButtonGroup = ButtonGroup.new()
@export var size_flags : Control.SizeFlags = Control.SIZE_EXPAND_FILL:
	set(v):
		size_flags = v
		for child in hbox.get_children():
			child.size_flags_horizontal = size_flags

var hbox : HBoxContainer

func _ready() -> void:
	hbox = HBoxContainer.new()

	for child in get_children():
		create_tab_button_for(child)

	add_child(hbox)
	move_child(hbox, 0)

	child_entered_tree.connect(on_child_entered)
	child_exiting_tree.connect(on_child_exited)
	
	theme_changed.connect(func() -> void:
		for child: Control in hbox.get_children():
			child.theme = theme;
		)

func on_child_entered(node: Node) -> void:
	create_tab_button_for(node)

func on_child_exited(node: Node) -> void:
	for child in hbox.get_children():
		if child.text == node.name:
			child.queue_free()

func create_tab_button_for(for_node: Control) -> void:
	if not btngroup:
		return

	var btn := Button.new()
	btn.text = for_node.name 
	btn.toggle_mode = true 
	btn.button_group = btngroup
	btn.size_flags_horizontal = size_flags
	
	for_node.renamed.connect(func() -> void: btn.text = for_node.name)

	for_node.visibility_changed.connect(func() -> void:
		for button in btngroup.get_buttons():
			btn.set_pressed_no_signal(false)

		btn.button_pressed = for_node.visible
		)

	btn.toggled.connect(func(toggle: bool) -> void:
		for_node.visible = toggle
		)

	hbox.add_child(btn)

	btn.button_pressed = true
