extends Node

func execute(options: Dictionary = {}) -> void:
	#don't forget to enable processing when the animation finishes (see code in player_controller)
	Manager.instance.player.do_processing = false;
	Manager.instance.player.animation_controller.one_shot("attack_melee");
