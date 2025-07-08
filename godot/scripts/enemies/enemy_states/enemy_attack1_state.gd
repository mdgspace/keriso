class_name EnemyAttack1State extends EnemyState

var distance: float
var attack_completed: bool = false

func enter() -> void:
	enemy.velocity.x = 0
	animatedsprite2d.play("Attack1")
	attack_completed = false
	
	# Set facing toward player when starting attack
	var player_direction = sign(enemy.to_player.x)
	if (player_direction) <  0:
		enemy.set_facing_direction(-player_direction)
	else:
		enemy.set_facing_direction(player_direction)
	
	# Connect to animation finished signal if not already connected
	if not animatedsprite2d.animation_finished.is_connected(_on_animation_finished):
		animatedsprite2d.animation_finished.connect(_on_animation_finished)

func physics_process(delta: float) -> void:
	distance = enemy.to_player.length()
	
	# Don't call handle_facing() during attack - keep facing locked
	# enemy.handle_facing()  # REMOVED
	
	# Check if player moved too far away during attack
	if distance > enemy.attack_range * 1.5 and attack_completed:
		movement_state_machine.transition("EnemyIdleState")
		return
	
	# Check if attack animation is nearly finished and player is out of range
	if distance > enemy.attack_range and animatedsprite2d.frame >= 5:
		movement_state_machine.transition("EnemyIdleState")
		return

func _on_animation_finished() -> void:
	attack_completed = true
	
	# After attack, decide next state based on player position
	if distance <= enemy.attack_range and enemy.can_see_player():
		# Player still in range - continue following
		movement_state_machine.transition("EnemyFollowState")
	else:
		# Player out of range - go idle
		movement_state_machine.transition("EnemyIdleState")

func exit() -> void:
	# Clean up
	attack_completed = false
	
	# Disconnect signal to prevent memory leaks
	if animatedsprite2d.animation_finished.is_connected(_on_animation_finished):
		animatedsprite2d.animation_finished.disconnect(_on_animation_finished)

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
