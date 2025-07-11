@abstract class_name Interactable extends Node3D

signal interacted(button_index: int);

var click_area: Area3D;

@export_group("Properties")
@export var can_interact: bool = true;
@export var interactable_id: String;
var last_button_index: int = 0;

func _ready() -> void:
	click_area = $clickable_area;
	if Manager.instance:
		if click_area:
			click_area.collision_layer = Manager.instance.interactable_layer;
			click_area.set_meta("interactable", self);
		else:
			Debug.warn("No area found for interactable %s." % interactable_id)
			
func interact(btn_index: int) -> void:
	if !can_interact:
		return;
		
	last_button_index = btn_index;
	interacted.emit(btn_index);
	on_interact();
	
@abstract func on_interact() -> void;
		
func set_interactable(b: bool) -> void:
	can_interact = b;
	for collision_shape in click_area.get_children():
		if collision_shape is CollisionShape3D:
			collision_shape.set_deferred("disabled", !b);
