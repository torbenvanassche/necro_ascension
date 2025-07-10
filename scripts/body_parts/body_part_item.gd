class_name BodyPart extends ItemResource;

enum Type {
	UNDEFINED,
	HEAD,
	MAIN_HAND,
	OFF_HAND,
	BODY,
	LEGS,
	CORE
}

@export var type: Type = Type.UNDEFINED;
