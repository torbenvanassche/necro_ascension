class_name AnimationMachine extends Node

var animation_player: AnimationPlayer
var animation_tree: AnimationTree

var animation_state: String = "";
var _state_holder: Array[AnimationControllerState]
var current_state: AnimationControllerState

func _init(anim_tree: AnimationTree) -> void:
	animation_tree = anim_tree
	animation_player = anim_tree.get_node(anim_tree.anim_player)
	animation_tree.animation_finished.connect(_on_animation_completed)
	
func _on_animation_completed(anim_name: String) -> void:
	search_state_by_meta("animation_name", anim_name).execute_anim_ended();
	
func add_state(state: AnimationControllerState) -> void:
	_state_holder.append(state);
	
func add_callback(state: String, c: Callable) -> void:
	var s := get_state(state);
	s.set_meta("animation_name", get_animation_name_from_node("%s_anim" % s.state_name));
	s.animation_ended_callables.append(c);
	
func get_animation_name_from_node(node_name: String) -> String:
	return (animation_tree.tree_root.get_node(node_name) as AnimationNodeAnimation).animation;
	
func search_state_by_meta(meta_id: String, to_match: Variant) -> AnimationControllerState:
	for s in _state_holder:
		if s.has_meta(meta_id) && s.get_meta(meta_id) == to_match:
			return s;
	return null;

func get_state(state: String = animation_state) -> AnimationControllerState:
	var items := _state_holder.filter(func(x: AnimationControllerState) -> bool: return x.state_name == state)
	if items.size() != 0:
		return items[0]
	else:
		Debug.err("%s does not exist in the animation controller" % state)
		return null
		
func blend_state(state: String, blend_to: float, delta: float) -> void:
	var s := get_state(state);
	animation_tree.set(s.blend_path, s.set_blend_value(blend_to, delta));
	
func one_shot(state: String) -> void:
	var s := get_state(state);
	if s.state_type == AnimationControllerState.StateType.ONESHOT:
		animation_tree.set(s.blend_path, true);
