class_name BodyPart extends ItemResource;

enum Type {
	UNDEFINED,
	HEAD,
	MAIN_HAND,
	OFF_HAND,
	BODY,
	LEGS,
	MISC,
	CORE
}

@export var type: Type = Type.UNDEFINED;
@export var scene_info: SceneInfo;
var runtime_mesh: MeshInstance3D;

func type_as_string() -> String:
	return Type.find_key(type)
