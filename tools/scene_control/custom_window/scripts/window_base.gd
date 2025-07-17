class_name DraggableControl
extends Control

@export var id: String = "";

@onready var vp := get_viewport()
@onready var draggable_area: MarginContainer = $MarginContainer;
@onready var close_button: Button = $close_button;
@onready var content_panel: Panel = $MarginContainer/Panel;

@export_enum("mouse", "center", "override") var position_options: String = "center";
var initial_position: Vector2;

@export var store_position: bool = false;
@export var override_position: Vector2;
@export var override_size: Vector2;
@export var return_on_close: bool = true;
@export var topbar_height: int = 50;

@export var element: CanvasItem;

signal close_requested();

var dragging := false
var stored_position:Vector2;
var drag_offset: Vector2;

func _ready() -> void:
	vp = get_viewport();
	close_button.pressed.connect(close_window);
	close_requested.connect(close_window)
	draggable_area.gui_input.connect(handle_input)
	
	if override_size != Vector2.ZERO:
		set_deferred.call_deferred("size", override_size);
	
func on_enable(_options: Dictionary = {}) -> void:
	if visible:
		return
	visible = true;
	
	match position_options:
		"mouse":
			initial_position = get_tree().root.get_viewport().get_mouse_position();
		"center":
			initial_position = get_viewport_rect().size / 2
		"override":
			initial_position = override_position;
	position = initial_position - size / 2;
	
	if store_position:
		position = stored_position;

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		dragging = event.pressed
		drag_offset = get_viewport().get_mouse_position() - global_position;
	elif dragging and event is InputEventMouseMotion:
		global_position = get_viewport().get_mouse_position() - drag_offset;
	else:
		return
	vp.set_input_as_handled()

func close_window() -> void:
	if store_position:
		stored_position = position;
	SceneManager.instance.remove_scene(SceneManager.instance.node_to_info(self), false);
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel") && visible:
		vp.set_input_as_handled()
		close_requested.emit()
