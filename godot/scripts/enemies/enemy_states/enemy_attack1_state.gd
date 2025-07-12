class_name EnemyAttack1State extends EnemyState

var distance: float

func enter() -> void:
	enemy.velocity.x = 0
	enemy.animation_state = "attack1"
	
	# Set facing toward player when starting attack
	var player_direction = sign(enemy.to_player.x)
	enemy.set_facing_direction(player_direction)
	
func attack1finished()->void:
	print("Attack1finishcall")
	if distance <= enemy.attack_range and enemy.can_see_player():
		# Player still in range - continue following
		movement_state_machine.transition("EnemyFollowState")
	else:
		# Player out of range - go idle
		movement_state_machine.transition("EnemyIdleState")
		
func physics_process(delta: float) -> void:
	distance = enemy.to_player.length()
	
func exit() -> void:
	# Clean up
	pass

func get_state_name() -> String:
	return "EnemyAttack1State"

# Alternative version without signals (simpler)
# class_name EnemyAttack1State extends EnemyState
# 
# var distance: float
# 
# func enter() -> void:
# 	enemy.velocity.x = 0
# 	animatedsprite2d.play("Attack1")
# 	
# 	# Lock facing direction toward player
# 	var player_direction = sign(enemy.to_player.x)
# 	if abs(player_direction) > 0:
# 		enemy.set_facing_direction(player_direction)
# 
# func physics_process(delta: float) -> void:
# 	distance = enemy.to_player.length()
# 	
# 	# Don't change facing during attack
# 	# enemy.handle_facing()  # REMOVED
# 	
# 	# Exit conditions
# 	if not animatedsprite2d.is_playing():
# 		# Attack animation finished
# 		if distance <= enemy.attack_range and enemy.can_see_player():
# 			movement_state_machine.transition("EnemyFollowState")
# 		else:
# 			movement_state_machine.transition("EnemyIdleState")
# 	elif distance > enemy.attack_range * 1.5:
# 		# Player moved too far away during attack
# 		movement_state_machine.transition("EnemyIdleState")
# 
# func get_state_name() -> String:
# 	return "EnemyAttack1State"
