class_name EnemyFollowState extends EnemyState
var distance: float 
func enter() -> void:
	animatedsprite2d.play("Run")

func physics_process(delta: float) -> void:
	distance = enemy.to_player.length()
	print(distance)
	if enemy.to_player.x>0:
		enemy.velocity.x = enemy.run_speed
	else :
		enemy.velocity.x = -enemy.run_speed
	enemy.handle_facing()
	if distance < enemy.attack_range:
		action_state_machine.transition("EnemyAttack1State")
	if enemy.low_collision:
		movement_state_machine.transition("EnemyJumpState")
	if !enemy.down_collision:
		movement_state_machine.transition("EnemyJumpDownState")
	if !enemy.can_see_player():
		movement_state_machine.transition("EnemyIdleState")
	
	
func get_state_name() -> String:
	return "EnemyFollowState"
