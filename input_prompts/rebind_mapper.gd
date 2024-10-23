class_name InputDisplayer extends Button

@export var action_name: Label;
@export var action_image: TextureRect;
			
func set_key(str: String):
	var entry = InputManager.keys.keyboard.get(str)
	if entry:
		(action_image.texture as AtlasTexture).region = Rect2(entry[0] * InputManager.keys.rect_size[0], entry[1] * InputManager.keys.rect_size[1], InputManager.keys.rect_size[0] * entry[2], InputManager.keys.rect_size[1] * entry[3]);

func set_label(str: String):
	action_name.text = str;

func _ready():
	action_image.texture = action_image.texture.duplicate(true);
