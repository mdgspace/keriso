class_name EnemyRoamState extends EnemyState

var roam_duration: float = 5.0
var roam_timer: float = 0.0
var roam_direction: int = 0
var small_timer:float = 0.0

func enter() -> void:
	# Choose random direction
	roam_direction = [-1, 1][randi() % 2]
	print("Start Roaming Direction",roam_direction)
	roam_timer = roam_duration
	# Set initial facing direction
	enemy.set_facing_direction(roam_direction)
	enemy.animation_state = "walk"

func physics_process(delta: float) -> void:
	roam_timer -= delta
	small_timer += delta
	# Priority 1: Player spotted
	if enemy.can_see_player():
		movement_state_machine.transition("EnemyFollowState")
		return
	
	if enemy.low_collision &&  small_timer>2:
		# Hit wall - turn around
		roam_direction *= -1
		small_timer = 0.0
		print("flipping ",roam_direction)
		#enemy.flip()
		enemy.set_facing_direction(roam_direction)
		roam_timer = roam_duration  # Reset timer
		return
	
	# Normal movement
	enemy.velocity.x = enemy.walk_speed * roam_direction
	
	#print(roam_direction)
	# Transition to idle after roam time
	if roam_timer <= 0:
		movement_state_machine.transition("EnemyIdleState")

func get_state_name() -> String:
	return "EnemyRoamState"

# Alternative version with more natural roaming behavior
# class_name EnemyRoamState extends EnemyState
# 
# var roam_duration: float = 5.0
# var roam_timer: float = 0.0
# var roam_direction: int = 0
# var direction_change_timer: float = 0.0
# var direction_change_interval: float = 2.0  # Change direction every 2 seconds
# 
# func enter() -> void:
# 	roam_direction = [-1, 1][randi() % 2]
# 	roam_timer = roam_duration
# 	direction_change_timer = direction_change_interval
# 	animatedsprite2d.play("Walk")
# 	enemy.set_facing_direction(roam_direction)
# 
# func physics_process(delta: float) -> void:
# 	roam_timer -= delta
# 	direction_change_timer -= delta
# 	
# 	# Player spotted
# 	if enemy.can_see_player():
# 		movement_state_machine.transition("EnemyFollowState")
# 		return
# 	
# 	# Random direction change
# 	if direction_change_timer <= 0.0:
# 		if randf() < 0.3:  # 30% chance to change direction
# 			roam_direction *= -1
# 			enemy.set_facing_direction(roam_direction)
# 		direction_change_timer = direction_change_interval
# 	
# 	# Environmental hazards
# 	if not enemy.down_collision or enemy.low_collision:
# 		roam_direction *= -1
# 		enemy.set_facing_direction(roam_direction)
# 		direction_change_timer = direction_change_interval
# 	
# 	# Apply movement
# 	enemy.velocity.x = enemy.walk_speed * roam_direction
# 	
# 	# End roaming
# 	if roam_timer <= 0:
# 		movement_state_machine.transition("EnemyIdleState")
# 
# func get_state_name() -> String:
# 	return "EnemyRoamState"
