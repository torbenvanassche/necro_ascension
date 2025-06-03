class_name AnimationMachine extends Node

var animation_player: AnimationPlayer
var animation_tree: AnimationTree

var animation_state: String = "";
var _state_holder: Array[AnimationControllerState]
var current_state: AnimationControllerState
var anim_state: AnimationNodeStateMachinePlayback;
var animation_prefix: String;

var _on_end_callbacks: Dictionary[String, Array];

func _init(anim_tree: AnimationTree, anim_prefix: String) -> void:
	animation_tree = anim_tree
	animation_prefix = anim_prefix;
	
	animation_player = anim_tree.get_node(anim_tree.anim_player)
	animation_tree.animation_finished.connect(_on_animation_completed)
	anim_state = animation_tree.get("parameters/playback");
	
func _on_animation_completed(anim_name: String) -> void:
	if _on_end_callbacks.has(anim_name):
		for c: Callable in _on_end_callbacks[anim_name]:
			c.call();
	
func add_state(state: AnimationControllerState) -> void:
	_state_holder.append(state);
	
func add_animation_end_callback(animation_name: String, c: Callable) -> void:
	var prefixed_name: String = "%s/%s" % [animation_prefix, animation_name];
	if animation_tree.has_animation(prefixed_name):
		if _on_end_callbacks.has(prefixed_name):
			_on_end_callbacks[prefixed_name].append(c);
		else:
			_on_end_callbacks.set(prefixed_name, [c])
	
func get_animation_name_from_node(node_name: String) -> String:
	var anim_node: AnimationRootNode = animation_tree.tree_root.get_node(node_name);
	if anim_node && anim_node is AnimationNodeAnimation:
		return anim_node.animation;
	else:
		return "";
	
func search_state_by_meta(meta_id: String, to_match: Variant) -> AnimationControllerState:
	for s in _state_holder:
		if s.has_meta(meta_id) && s.get_meta(meta_id) == to_match:
			return s;
	return null;
	
func set_state_on_machine(state: String) -> void:
	var s := get_state(state);
	if s && s.state_type == AnimationControllerState.StateType.STATE:
		anim_state.travel(s.blend_path)

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
	else:
		Debug.message("Animation %s is not a one-shot." % s.state_name)
		
func set_parameter(state: String, value: Variant) -> void:
	var s := get_state(state);
	if s.state_type == AnimationControllerState.StateType.PARAMETER:
		animation_tree.set(s.blend_path, value)
