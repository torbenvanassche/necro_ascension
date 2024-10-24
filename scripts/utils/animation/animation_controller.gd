class_name AnimationMachine extends Node

var animation_player: AnimatedSprite3D;
var animation_state: String = "":
	set(value):
		current_state = get_state(value)
		if current_state && animation_player.animation != value && not one_shot_active:
			animation_player.animation = current_state.state_name;
			animation_player.play(animation_player.animation)
		animation_state = value;

var state_holder: Array[AnimationControllerState];
var current_state: AnimationControllerState;
var one_shot_active: bool = false;

signal one_shot_ended(anim_name: String);

func _init(anim_tree: AnimatedSprite3D, animation_controller_states: Array[AnimationControllerState]) -> void:
	animation_player = anim_tree;
	state_holder = animation_controller_states
	process_mode = PROCESS_MODE_INHERIT;
		
func one_shot(state: String, on_end: String = animation_state) -> void:
	if not animation_player.animation_finished.is_connected(_on_one_shot_end):
		one_shot_active = true;
		animation_player.animation = get_state(state).state_name;
		animation_state = get_state(state).state_name;
		animation_player.animation_finished.connect(_on_one_shot_end.bind(on_end), CONNECT_ONE_SHOT);
	
func _on_one_shot_end(on_end: String) -> void:
	one_shot_active = false;
	animation_player.play(on_end);
	one_shot_ended.emit();
		
func get_state(state: String = animation_state) -> AnimationControllerState:
	var items: Array[AnimationControllerState] = state_holder.filter(func(x: AnimationControllerState) -> bool: return x.state_name == state);
	if items.size() != 0:
		return items[0];
	else:
		assert("%s does not exist in the animation controller" % state);
		return null;
