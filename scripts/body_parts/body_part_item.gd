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

func type_as_string() -> String:
	for name:String in Type.keys():
		if Type[name] == type:
			return name;
	return "UNDEFINED"
