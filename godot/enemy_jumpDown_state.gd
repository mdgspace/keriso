##Currently will only be tranistioned from follow state
class_name EnemyJumpDownState extends EnemyState
##Have to set the animation frame values enemy wise
func enter() -> void:
	enemy.velocity.x =0
	animatedsprite2d.play("JumpDown")

func physics_process(delta: float) -> void:
	if animatedsprite2d.frame==0 :
		enemy.jump()
	
	if enemy.to_player.x>0:
		enemy.velocity.x = enemy.run_speed
	else :
		enemy.velocity.x = -enemy.run_speed
		
	enemy.handle_facing()
	if enemy.is_on_floor() && animatedsprite2d.frame>0:
		movement_state_machine.transition("EnemyIdleState")

func get_state_name() -> String:
	return "EnemyJumpDownState"
