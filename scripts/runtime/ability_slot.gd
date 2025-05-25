class_name AbilitySlot extends Button

@export var ability_data: AbilityResource:
	set(value):
		if value != null:
			ability_data = value;
			_ready();

@export var keybind_action: String;

@onready var cooldown_overlay: ProgressBar = $ability_texture/cooldown_overlay;
@onready var ability_texture: TextureRect = $ability_texture;
var ability_runtime: AbilityRuntime;

func _ready() -> void:
	process_mode = PROCESS_MODE_INHERIT;
	if not ability_data or not InputMap.has_action(keybind_action):
		process_mode = PROCESS_MODE_DISABLED
		return
		
	ability_runtime = AbilityRuntime.new(ability_data);
	pressed.connect(ability_runtime.execute)
	self.add_child(ability_runtime)
	cooldown_overlay.value = 0;
	
	if ability_texture != null:
		ability_texture.texture = ability_data.ui_sprite

func _process(_delta: float) -> void:
	cooldown_overlay.value = ability_runtime.cooldown_timer.time_left / ability_runtime.cooldown_timer.wait_time;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(keybind_action):
		ability_runtime.execute()
