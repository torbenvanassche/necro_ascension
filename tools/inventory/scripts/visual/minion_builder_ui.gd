class_name BodyBuilderUI extends ContentGroup

var parts: Array[MinionEquipmentSlotUI];
var minion: CreatureInstance;

func _ready() -> void:
	parts.assign(get_children().filter(func(child: Node)-> bool: return child is MinionEquipmentSlotUI));
	for part in parts:
		var c: ContentSlot = ContentSlot.new();
		part.set_content(c)
		data.append(c)
		c.changed.connect(_data_changed)
		
	var necro_table: SceneInfo = SceneManager.instance.get_scene_info("necromancy_table");
	var skeleton_fleshy: SceneInfo = SceneManager.instance.get_scene_info("skeleton_fleshy");
	var base_skeleton: SceneInfo = SceneManager.instance.get_scene_info("base_skeleton");

	SceneManager.instance.cache_scenes([
		necro_table, skeleton_fleshy, base_skeleton], func(_loaded_scenes: Array[SceneInfo]) -> void: 
			necro_table.get_instance().set_buildable(base_skeleton.get_instance());
			_assign_part(base_skeleton, (skeleton_fleshy.get_instance() as BodyPartDonor).get_part("head")))
	
func _data_changed() -> void:
	var minion_parts := parts.map(func(slot: MinionEquipmentSlotUI) -> BodyPart: return slot.contentSlot.get_content());
	for part: BodyPart in minion_parts.filter(func(p: Resource) -> bool: return p != null):
		part.scene_info.queue(_assign_part.bind(part))
		
func _assign_part(scene_info: SceneInfo, part: BodyPart) -> void:
	if not Manager.instance.object_pool.has_scene(scene_info):
		Manager.instance.object_pool.add_scene(scene_info)
	(scene_info.get_instance() as Skeleton).apply_part(part.type_as_string(), part.runtime_mesh)
