extends Node

func execute(options: Dictionary = {}) -> bool:
	#don't forget to enable processing when the animation finishes (see code in player_controller)
	Manager.instance.player.do_processing = false;
	
	Manager.instance.player.animation_controller.set_state_on_machine("attack_swing");
	return true;
