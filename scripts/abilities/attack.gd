extends Node

func execute(options: Dictionary = {}) -> bool:
	Manager.instance.player.on_attack_start();
	return true;
