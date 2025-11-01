class_name U_IdleState extends UpperBodyState

func get_state_name() -> String:
	return "U_IdleState"

func enter() -> void:
	player.U_anim_state = "U_IdleState"
	player.animation_tree.set("parameters/UpperBodyFSM/playback","U_Idle")

func physics_process(_delta: float) -> void:
	# Transition to attack directly from idle (draws weapon automatically)
	if Input.is_action_just_pressed("attack"):
		player.enter_stance() # This will handle the transition to Stance and Attack
		state_machine.transition("U_Attack1State")
		return
