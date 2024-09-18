class_name StateMachineController extends Node

var tree: AnimationNodeStateMachinePlayback;
var animation_state: String = "idle":
	set(value):
		current_state = get_state(value)
		if current_state && animation_state != value:
			match current_state.type:
				AnimationControllerState.StateType.STATE:
					tree.travel(current_state.state_name)
		animation_state = value;

var state_holder: Array[AnimationControllerState];
var blend_speed_modifier = 15;
var current_state: AnimationControllerState;

signal animation_finished(anim_name: String);

var blend_amounts: Dictionary;

func _init(anim_tree: AnimationNodeStateMachinePlayback, animation_controller_states: Array[AnimationControllerState]):
	tree = anim_tree;
	state_holder = animation_controller_states
	for anim in state_holder:
		if anim.type == AnimationControllerState.StateType.BLEND:
			blend_amounts[anim.path_in_tree] = 0;
	process_mode = PROCESS_MODE_INHERIT;
		
func one_shot(state: String):
	tree.set(get_state(state).path_in_tree, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
func get_state(state: String = animation_state) -> AnimationControllerState:
	var items: Array[AnimationControllerState] = state_holder.filter(func(x: AnimationControllerState): return x.state_name == state);
	if items.size() != 0:
		return items[0];
	else:
		assert("%s does not exist in the animation controller" % state);
		return null;
