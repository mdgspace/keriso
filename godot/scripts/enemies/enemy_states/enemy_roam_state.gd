class_name EnemyRoamState
extends EnemyState

var roam_duration := 5
var roam_timer := 0.0
var roam_direction := 0

func enter() -> void:
	roam_direction = [-1, 1][randi() % 2]
	roam_timer = roam_duration
	animatedsprite2d.play("Walk")

func physics_process(delta: float) -> void:
	if enemy.can_see_player():
		movement_state_machine.transition("EnemyFollowState")
	
	enemy.velocity.x = 40 * roam_direction
	roam_timer -= delta

	# Check wall in front using raycast
	if enemy.low_collision:
		print("Raycast colliding")
		roam_direction *= -1 
		enemy.velocity.x = 40 * roam_direction 
		
	enemy.handle_facing()
	# Transition to idle after roam time
	if roam_timer <= 0:
		movement_state_machine.transition("EnemyIdleState")

func get_state_name() -> String:
	return "EnemyRoamState"
