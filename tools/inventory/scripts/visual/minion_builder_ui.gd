class_name BodyBuilderUI extends ContentGroup

var parts: Array[MinionPartSlotUI];
var minion: CreatureInstance;

func _ready() -> void:
	parts.assign(get_children().filter(func(child: Node)-> bool: return child is MinionPartSlotUI));
	for part in parts:
		var c: ContentSlot = ContentSlot.new();
		part.contentSlot = c;
		c.changed.connect(_data_changed)
		data.append(c)
		
	SceneManager.instance.get_scene_info("base_skeleton").try_call(_on_minion_ready)
		
func _on_minion_ready(scene_info: SceneInfo) -> void:
	minion = scene_info.get_instance()
	Manager.instance.object_pool.add_child(minion)
		
func _data_changed() -> void:
	var minion_parts := parts.map(func(slot: MinionPartSlotUI) -> BodyPart: return slot.contentSlot.get_content());
	for part: BodyPart in minion_parts.filter(func(p: Resource) -> bool: return p != null):
		part.scene_info.try_call(_assign_part.bind(part))
		
func _assign_part(scene_info: SceneInfo, part: BodyPart) -> void:
	Manager.instance.object_pool.add_child(scene_info.get_instance())
	var to_add: Node = (part.scene_info.get_instance() as BodyPartDonor).get_part("head");
	
	(minion as Skeleton).apply_part("head", to_add)
	
