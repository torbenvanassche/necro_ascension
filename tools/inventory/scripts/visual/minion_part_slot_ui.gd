class_name MinionPartSlotUI extends ContentSlotUI

@export var part_type: BodyPart.Type;

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return super(_at_position, _data) && _data.slot.contentSlot.get_content().type == part_type;

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var src_slot: ContentSlot = (data as DragData).slot.contentSlot
	var dest_slot: ContentSlot = contentSlot
	
	dest_slot.set_content(src_slot.get_content().duplicate(false));
