class_name CombatHandler
extends Area3D

@onready var collider: CollisionShape3D = $CollisionShape3D;

var attacking: bool = false:
	set(value):
		attacking = value;
		monitorable = attacking;
		monitoring = attacking;
		collider.visible = attacking;

func _ready() -> void:
	body_entered.connect(_on_attack);
	collider.visible = false;
	
func attack(direction: String):
	match direction:
		"left":
			self.global_rotation_degrees = Vector3(0, 90, 0);
		"right":
			self.global_rotation_degrees = Vector3(0, -90, 0);
		"up":
			self.global_rotation_degrees = Vector3(0, 0, 0);
		"down":
			self.global_rotation_degrees = Vector3(0, 180, 0);
	attacking = true;

func _on_attack(body: Node3D):
	print(body.name)
