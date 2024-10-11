class_name AbilitySlot extends Button

@export var ability_data: AbilityResource;

@onready var cooldown_overlay: ProgressBar = $border_texture/ability_texture/cooldown_overlay;
@onready var ability_texture: TextureRect = $border_texture/ability_texture;
var ability_runtime: AbilityRuntime;

func _ready():
	ability_runtime = AbilityRuntime.new(ability_data);
	pressed.connect(func(): ability_runtime.execute())
	self.add_child(ability_runtime)
	cooldown_overlay.value = 0;
	
	if ability_texture != null:
		ability_texture.texture = ability_data.ui_sprite
		
func _process(delta: float) -> void:
	cooldown_overlay.value = ability_runtime.cooldown_timer.time_left / ability_runtime.cooldown_timer.wait_time;
