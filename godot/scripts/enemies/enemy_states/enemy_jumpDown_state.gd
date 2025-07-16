class_name EnemyJumpDownState extends EnemyState
##Have to set the animation frame values enemy wise
@export var endjumpdown:bool
func enter() -> void:
	enemy.velocity.x =0
	endjumpdown=false
	enemy.animation_state = "jumpdown"
	var player_direction = sign(enemy.to_player.x)
	enemy.set_facing_direction(player_direction)
	enemy.jump()
	

func physics_process(delta: float) -> void:
		
	if enemy.to_player.x>0:
		enemy.velocity.x = enemy.run_speed
	else :
		enemy.velocity.x = -enemy.run_speed
		
	if enemy.is_on_floor() && endjumpdown:
		movement_state_machine.transition("EnemyIdleState")

func get_state_name() -> String:
	return "EnemyJumpDownState"
