extends Node
class_name Manager

var player: Player;
var camera: Camera3D;

static var instance: Manager;
var scroll_in_use: bool = false;

@export var resource_manager: ResourceManager;
@export var unit_controller: UnitController;

signal input_mode_changed(is_keyboard: bool);
var input_mode_is_keyboard: bool = true:
	set(value):
		input_mode_is_keyboard = value;
		input_mode_changed.emit(value)

func _init() -> void:
	Manager.instance = self;
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	input_mode_is_keyboard = event is InputEventKey || event is InputEventMouse;
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		pause();
		
func pause(pause_game: bool = !get_tree().paused) -> void:
	get_tree().paused = pause_game
	if pause_game:
		SceneManager.instance.set_active_scene("paused", SceneConfig.new(false));
