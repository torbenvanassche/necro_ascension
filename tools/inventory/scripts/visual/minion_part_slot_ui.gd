class_name MinionPartSlotUI extends ContentSlotUI

@export var part_type: BodyPart.TYPE;

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return super(_at_position, _data) && _data.type == part_type;
