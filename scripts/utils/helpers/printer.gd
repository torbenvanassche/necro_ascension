class_name Printer
extends Control

var print_tween: Tween
var is_printing = false

@export var print_delay: float = 0.5
@onready var finished_indicator: TextureRect = $Sprite2D;
@onready var text_box: Label = $MarginContainer2/text_box;

signal print_done();
signal dialogue_ended();

func _ready():
	visible = false;
	finished_indicator.visible = false;
	
func show_text(txt: String) -> void:
	if txt == "":
		clear();
		dialogue_ended.emit();
		return;
	
	is_printing = true
	visible = true;
	text_box.visible_characters = 0
	text_box.text = txt;
	
	print_tween = create_tween()
	print_tween.tween_property(text_box, "visible_characters", txt.length(), print_delay * txt.length())
	print_tween.finished.connect(_on_tween_complete)
	
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		if is_printing:
			fast_forward()
		else:
			print_done.emit();
			
func clear() -> void:
	visible = false;
	is_printing = false;
	text_box.visible_characters = 0
	if print_tween && print_tween.is_running():
		print_tween.stop();

func fast_forward() -> void:
	print_tween.stop();
	text_box.visible_ratio = 1;
	print_tween.finished.emit()

func _on_tween_complete() -> void:
	finished_indicator.visible = true;
	is_printing = false
