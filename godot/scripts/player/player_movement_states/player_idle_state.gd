class_name PlayerIdleState extends PlayerState


static var state_name = "PlayerIdleState"

const STOP_FORCE: float = 15


func process(_delta: float) -> void:
	if InputNode.is_just_pressed("jump"):
		movement_state_machine.transition(PlayerJumpState.state_name)
		pass
	
	animatedsprite2d.play("idle")
	player.handle_facing()


func physics_process(_delta: float) -> void:
	if InputNode.is_just_pressed("attack"):
		action_state_machine.transition(PlayerAttackState.state_name)
	if player.horizontal_input != 0.0:
		movement_state_machine.transition(PlayerMovementState.state_name)
		pass
	
	# Apply stop force if it's moving
	if player.velocity.x != 0.0:
		player.velocity.x = move_toward(player.velocity.x, 0, STOP_FORCE)
		
		
func get_state_name() -> String:
	return state_name
