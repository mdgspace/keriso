##Currently will only be tranistioned from follow state
class_name EnemyJumpState extends EnemyState


func enter() -> void:
	enemy.animation_state = "jump"
	var player_direction = sign(enemy.to_player.x)
	enemy.set_facing_direction(player_direction)


func physics_process(delta: float) -> void:

	if enemy.to_player.x>0:
		enemy.velocity.x = enemy.run_speed
	else :
		enemy.velocity.x = -enemy.run_speed
		
	#if enemy.is_on_floor():
		

#func exit() -> void:

func get_state_name() -> String:
	return "EnemyJumpState"
