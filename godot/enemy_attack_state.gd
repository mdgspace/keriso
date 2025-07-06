class_name EnemyAttack1State extends EnemyState

func enter() -> void:
	animatedsprite2d.play("Attack1")

func physics_process(delta: float) -> void:
	pass

func get_state_name() -> String:
	return "EnemyAttack1State"
