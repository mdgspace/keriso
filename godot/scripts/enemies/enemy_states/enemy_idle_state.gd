class_name EnemyIdleState extends EnemyState

func enter() -> void:
	enemy.velocity.x = 0
	animatedsprite2d.play("Idle")

func physics_process(delta: float) -> void:
	if enemy.can_see_player():
		movement_state_machine.transition("EnemyFollowState")
	if randi() % 100 < 2:
		movement_state_machine.transition("EnemyRoamState")
	
func get_state_name() -> String:
	return "EnemyIdleState"
