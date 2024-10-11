class_name AbilitySlot extends Button

@export var ability_data: AbilityResource;
@export var keybind_action: String;

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
		
	if not InputMap.has_action(keybind_action):
		Debug.err("%s is not a valid keymapping." % keybind_action)
		process_mode = PROCESS_MODE_DISABLED
		
func _process(delta: float) -> void:
	cooldown_overlay.value = ability_runtime.cooldown_timer.time_left / ability_runtime.cooldown_timer.wait_time;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(keybind_action):
		ability_runtime.execute()
