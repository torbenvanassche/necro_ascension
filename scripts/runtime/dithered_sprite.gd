extends Sprite3D

@onready var shader: Shader = preload("res://shaders/light_dither_with_alpha.gdshader")
var material: ShaderMaterial;

func _ready() -> void:
	material = ShaderMaterial.new();
	material.shader = shader;
	
	self.material_override = material;
	material.set_shader_parameter("Transparent", true);

func _process(delta: float) -> void:
	var tex: Texture2D = self.texture;
	if material and material is ShaderMaterial:
		material.set_shader_parameter("BaseTexture", tex)
