class_name AnimationMachine extends Node

var animation_player: AnimationPlayer;
var animation_state: String = "":
	set(value):
		current_state = get_state(value)
		if current_state && animation_player.current_animation != value:
			animation_player.current_animation = current_state.state_name;
			animation_player.play(animation_player.current_animation)
		animation_state = value;

var state_holder: Array[AnimationControllerState];
var current_state: AnimationControllerState;

func _init(anim_player: AnimationPlayer, animation_controller_states: Array[AnimationControllerState]) -> void:
	animation_player = anim_player;
	state_holder = animation_controller_states
	process_mode = PROCESS_MODE_INHERIT;
		
func get_state(state: String = animation_state) -> AnimationControllerState:
	var items: Array[AnimationControllerState] = state_holder.filter(func(x: AnimationControllerState) -> bool: return x.state_name == state);
	if items.size() != 0:
		return items[0];
	else:
		Debug.err("%s does not exist in the animation controller" % state);
		return null;
