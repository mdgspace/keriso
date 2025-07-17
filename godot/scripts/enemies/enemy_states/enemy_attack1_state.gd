class_name EnemyAttack1State extends EnemyState

var distance: float

func enter() -> void:
	enemy.velocity.x = 0
	enemy.animation_state = "attack1"
	
	# Set facing toward player when starting attack
	var player_direction = sign(enemy.to_player.x)
	enemy.set_facing_direction(player_direction)
	enemy.perform_attack()
		
func physics_process(delta: float) -> void:
	distance = enemy.to_player.length()
	
func exit() -> void:
	# Clean up
	pass

func get_state_name() -> String:
	return "EnemyAttack1State"
