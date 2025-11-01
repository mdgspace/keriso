class_name L_RunState extends LowerBodyState

const ACCELERATION: float = 1000.0

func get_state_name() -> String:
	return "L_RunState"

func enter() -> void:
	player.animation_tree.set("parameters/LowerBodyFSM/playback", "Run")

func physics_process(delta: float) -> void:
	# Update facing direction
	player.handle_facing()

	# Apply acceleration
	player.velocity.x = move_toward(player.velocity.x, player.MAX_SPEED * player.horizontal_input, ACCELERATION * delta)

	# --- Transitions ---
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition("L_JumpState")
		return

	if player.horizontal_input == 0.0:
		state_machine.transition("L_IdleState")
		return
