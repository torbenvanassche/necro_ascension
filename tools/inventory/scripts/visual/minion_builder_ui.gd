class_name BodyBuilderUI extends ContentGroup

var parts: Array[MinionPartSlotUI];

func _ready() -> void:
	parts.assign(get_children().filter(func(child: Node)-> bool: return child is MinionPartSlotUI));
	for part in parts:
		var c: ContentSlot = ContentSlot.new();
		part.contentSlot = c;
		data.append(c)
		
