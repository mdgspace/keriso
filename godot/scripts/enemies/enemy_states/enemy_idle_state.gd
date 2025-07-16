class_name EnemyIdleState extends EnemyState

var face_player_timer: float = 0.0
var face_update_interval: float = 0.5  # Check every 0.5 seconds
var distance_to_player: float
var attack_timer: float = 0.0
	
func enter() -> void:
	enemy.velocity.x = 0
	enemy.animation_state = "idle"
	face_player_timer = 0.0
	attack_timer = enemy.attack_cooldown
	
func physics_process(delta: float) -> void:
	attack_timer = max(0.0, attack_timer - delta)
	face_player_timer += delta
	distance_to_player = enemy.to_player.length()
	
	# Periodically face toward player if visible
	if face_player_timer >= face_update_interval:
		face_player_timer = 0.0
		
	if distance_to_player <= enemy.attack_range and attack_timer > 0:
		return
		
	if enemy.can_see_player():
		movement_state_machine.transition("EnemyFollowState")
	
	if randi() % 100 < 2:
		movement_state_machine.transition("EnemyRoamState")

func get_state_name() -> String:
	return "EnemyIdleState"
