class_name L_JumpState extends LowerBodyState

const AIR_ACCELERATION: float = 600.0

func get_state_name() -> String:
	return "L_JumpState"

func enter() -> void:
	player.velocity.y = player.JUMP_VELOCITY

func physics_process(delta: float) -> void:
	# Allow for air control
	player.handle_facing()
	player.velocity.x = move_toward(player.velocity.x, player.MAX_SPEED * player.horizontal_input, AIR_ACCELERATION * delta)

	# --- Transition ---
	# Check one frame *after* landing
	if player.is_on_floor():
		state_machine.transition("L_IdleState")
		return
