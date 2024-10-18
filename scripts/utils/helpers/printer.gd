class_name Printer
extends Control

var print_tween: Tween
var _is_printing = false

@export var print_delay: float = 0.5
@onready var finished_indicator: TextureRect = $Sprite2D;
@onready var text_box: Label = $MarginContainer2/text_box;

func _ready():
	visible = false;
	
func print(txt: String):
	_is_printing = true
	visible = true;
	text_box.visible_characters = 0
	text_box.text = txt;
	
	print_tween = create_tween()
	print_tween.tween_property(text_box, "visible_characters", txt.length(), print_delay * txt.length())
	print_tween.finished.connect(_on_tween_complete)
	
func _input(_event):
	if Input.is_action_just_pressed("primary_click"):
		if _is_printing:
			print_tween.stop();
			text_box.visible_ratio = 1;
			print_tween.finished.emit()
		else:
			visible = false;

func _on_tween_complete():
	finished_indicator.visible = true;
	_is_printing = false
