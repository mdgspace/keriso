class_name EnemyFollowState extends EnemyState

var distance_to_player: float
#var attack_timer: float = 0.0
var follow_end_timer: float =0.0
func enter() -> void:
	enemy.animation_state = "run"
	#attack_timer = enemy.attack_cooldown
	follow_end_timer = 0.0

func physics_process(delta: float) -> void:
	# Update distance
	distance_to_player = enemy.to_player.length()
	
	# Handle movement and facing
	handle_movement_and_facing()
	
	#inscrease follow_end_timer
	if not enemy.can_see_player():
		follow_end_timer+=delta
		
	# Check transitions
	check_transitions()

func handle_movement_and_facing() -> void:
	var player_direction = sign(enemy.to_player.x)
	
	# Set facing direction FIRST (based on player position, not velocity)
	enemy.set_facing_direction(player_direction)
	
	# Then set movement
	if distance_to_player > enemy.attack_range:  # Get closer to player
		enemy.velocity.x = player_direction * enemy.run_speed
	else:  # Too close - back away or stop
		enemy.velocity.x = -player_direction * enemy.run_speed * 0.3

func check_transitions() -> void:
	# Environmental hazards (highest priority)
	if enemy.low_collision:
		movement_state_machine.transition("EnemyJumpState")
		return
	
	#if not enemy.down_collision:
		#movement_state_machine.transition("EnemyJumpDownState")
		#return
	
	# Attack if in range and ready
	# Change this to handling in idle
	if distance_to_player <= enemy.attack_range:
		if randf() < 0.5:
			movement_state_machine.transition("EnemyAttack1State")
		else:
			movement_state_machine.transition("EnemyAttack2State")
		return
	
	# Lost player after 1 sec of not seeing
	if not enemy.can_see_player() && follow_end_timer>1:
		movement_state_machine.transition("EnemyIdleState")
		return

func get_state_name() -> String:
	return "EnemyFollowState"

# Add this method to your main enemy script if you don't have it:
# func set_facing_direction(direction: float) -> void:
# 	if direction > 0:
# 		_facing = Facing.RIGHT
# 		scale.x = abs(scale.x)
# 	elif direction < 0:
# 		_facing = Facing.LEFT
# 		scale.x = -abs(scale.x)
