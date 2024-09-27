class_name AnimationMachine extends Node

var animation_player: AnimatedSprite3D;
var animation_state: String = "":
	set(value):
		current_state = get_state(value)
		if current_state && animation_state != value:
			animation_player.animation = current_state.state_name;
			animation_player.play(animation_player.animation)
		animation_state = value;

var state_holder: Array[AnimationControllerState];
var current_state: AnimationControllerState;

signal animation_finished(anim_name: String);

func _init(anim_tree: AnimatedSprite3D, animation_controller_states: Array[AnimationControllerState]):
	animation_player = anim_tree;
	animation_state = animation_controller_states[0].state_name;
	state_holder = animation_controller_states
	process_mode = PROCESS_MODE_INHERIT;
		
func one_shot(state: String):
	animation_player.animation = get_state(state).state_name;
	#track and signal when the animation has finished (and check if it is a looping one beforehand);
		
func get_state(state: String = animation_state) -> AnimationControllerState:
	var items: Array[AnimationControllerState] = state_holder.filter(func(x: AnimationControllerState): return x.state_name == state);
	if items.size() != 0:
		return items[0];
	else:
		assert("%s does not exist in the animation controller" % state);
		return null;
