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
	hbox = get_node("tabbar_container") if has_node("tabbar_container") else null
	if not hbox:
		hbox = HBoxContainer.new()
		hbox.name = "tabbar_container"
		add_child(hbox, true)

	for child in get_children():
		if child != hbox:
			create_tab_button_for(child)
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
	if not btngroup or for_node == hbox:
		return

	var btn := Button.new()
	btn.text = for_node.name 
	btn.toggle_mode = true 
	btn.button_group = btngroup
	btn.size_flags_horizontal = size_flags
	
	for_node.renamed.connect(func() -> void: btn.text = for_node.name)

	if for_node.is_connected("visibility_changed", _vis_changed.bind(btn, for_node)):
		for_node.visibility_changed.connect(_vis_changed.bind(btn, for_node))

	btn.toggled.connect(func(toggle: bool) -> void: for_node.visible = toggle)

	hbox.add_child(btn)
	btn.button_pressed = true

func _vis_changed(btn: Button, for_node: Control) -> void:
	for button in btngroup.get_buttons():
		btn.set_pressed_no_signal(false)

	btn.button_pressed = for_node.visible
