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
		
	#Load the base rig for simple skeleton meshes
	SceneManager.instance.get_scene_info("base_skeleton").queue(_on_base_rig_loaded)
		
func _on_base_rig_loaded(base_rig: SceneInfo) -> void:
	var sI: SceneInfo = SceneManager.instance.get_scene_info("necromancy_table");
	sI.queue(_on_ui_ready.bind(base_rig))
		
func _on_ui_ready(builder: SceneInfo, base_rig: SceneInfo) -> void:
	builder.get_instance().set_buildable(base_rig.get_instance())
	SceneManager.instance.get_scene_info("skeleton_fleshy").queue(_test_load.bind(base_rig))

func _test_load(fleshy: SceneInfo, base_rig: SceneInfo) -> void:
	var body_parts := fleshy.get_instance() as BodyPartDonor;
	_assign_part(base_rig, body_parts.get_part("head"))
	
func _data_changed() -> void:
	var minion_parts := parts.map(func(slot: MinionEquipmentSlotUI) -> BodyPart: return slot.contentSlot.get_content());
	for part: BodyPart in minion_parts.filter(func(p: Resource) -> bool: return p != null):
		part.scene_info.queue(_assign_part.bind(part))
		
func _assign_part(scene_info: SceneInfo, part: BodyPart) -> void:
	if not Manager.instance.object_pool.has_scene(scene_info):
		Manager.instance.object_pool.add_scene(scene_info)
	(scene_info.get_instance() as Skeleton).apply_part(part.type_as_string(), part.runtime_mesh)
