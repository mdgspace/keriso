class_name L_IdleState extends LowerBodyState

const STOP_FORCE: float = 1000.0 # Using a higher force for a snappier stop

func get_state_name() -> String:
	return "L_IdleState"

func enter() -> void:
	player.L_anim_state = "L_IdleState"
	player.animation_tree.set("parameters/LowerBodyFSM/playback", "L_Idle")

func physics_process(delta: float) -> void:
	# Apply friction
	player.velocity.x = move_toward(player.velocity.x, 0, STOP_FORCE * delta)

	# --- Transitions ---
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition("L_JumpState")
		return # Important: exit after a transition

	if player.horizontal_input != 0.0:
		state_machine.transition("L_RunState")
		return
