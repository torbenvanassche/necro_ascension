class_name Printer
extends Label

var print_tween: Tween
var _is_printing = false

@export var print_delay: float = 0.5
@onready var finished_indicator: TextureRect = $Sprite2D;

func _ready():
	visible = false;
	
func print(txt: String):
	_is_printing = true
	visible = true;
	self.visible_characters = 0
	self.text = txt;
	
	print_tween = create_tween()
	print_tween.tween_property(self, "visible_characters", txt.length(), print_delay * txt.length())
	print_tween.finished.connect(_on_tween_complete)
	
func _input(_event):
	if Input.is_action_just_pressed("primary_click"):
		if _is_printing:
			print_tween.stop();
			visible_ratio = 1;
			print_tween.finished.emit()
		else:
			visible = false;

func _on_tween_complete():
	finished_indicator.visible = true;
	_is_printing = false
