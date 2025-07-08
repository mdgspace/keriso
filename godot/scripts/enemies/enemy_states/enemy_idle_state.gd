class_name EnemyIdleState extends EnemyState

var face_player_timer: float = 0.0
var face_update_interval: float = 0.5  # Check every 0.5 seconds

func enter() -> void:
	enemy.velocity.x = 0
	animatedsprite2d.play("Idle")
	face_player_timer = 0.0

func physics_process(delta: float) -> void:
	face_player_timer += delta
	
	# Periodically face toward player if visible
	if face_player_timer >= face_update_interval:
		face_player_timer = 0.0
		
		#if enemy.can_see_player() and abs(enemy.to_player.x) > 20.0:
			#var player_direction = sign(enemy.to_player.x)
			#enemy.set_facing_direction(-player_direction)
	
	if enemy.can_see_player():
		movement_state_machine.transition("EnemyFollowState")
	
	if randi() % 100 < 2:
		movement_state_machine.transition("EnemyRoamState")

func get_state_name() -> String:
	return "EnemyIdleState"
