class_name InputDisplayer extends Button

@export_file("*.json") var dictionary_path: String;
@onready var action_name: Label = $MarginContainer/HBoxContainer/action_label;
@onready var action_image: TextureRect = $MarginContainer/HBoxContainer/action_prompt;

var _keys: Dictionary:
	get:
		if !_keys:
			_keys = FileUtils.load_json(dictionary_path)
		return _keys;

@export var key: String;
			
func set_rect(r: Rect2):
	(action_image.texture as AtlasTexture).region = r;

func _ready():
	(action_image.texture as AtlasTexture).atlas = (action_image.texture as AtlasTexture).atlas.duplicate();
	
	var entry = _keys.keyboard.get(key)
	if entry:
		set_rect(Rect2(entry[0] * _keys.rect_size[0], entry[1] * _keys.rect_size[1], _keys.rect_size[0] * entry[2], _keys.rect_size[1] * entry[3]))
