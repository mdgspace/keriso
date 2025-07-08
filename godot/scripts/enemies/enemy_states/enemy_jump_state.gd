##Currently will only be tranistioned from follow state
class_name EnemyJumpState extends EnemyState
func enter() -> void:
	animatedsprite2d.play("Jump")
	
	var player_direction = sign(enemy.to_player.x)
	if (player_direction) <  0:
		enemy.set_facing_direction(-player_direction)
	else:
		enemy.set_facing_direction(player_direction)

func physics_process(delta: float) -> void:
	if animatedsprite2d.frame==2 :
		enemy.jump()
	
	if enemy.to_player.x>0:
		enemy.velocity.x = enemy.run_speed
	else :
		enemy.velocity.x = -enemy.run_speed
		
	if enemy.is_on_floor()&& animatedsprite2d.frame==8:
		movement_state_machine.transition("EnemyIdleState")

func get_state_name() -> String:
	return "EnemyJumpState"
