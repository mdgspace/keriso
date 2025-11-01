class_name U_StanceState extends UpperBodyState

func get_state_name() -> String:
	return "U_StanceState"

func enter() -> void:
	player.U_anim_state = "U_StanceState"
	player.animation_tree.set("parameters/UpperBodyFSM/playback", "U_Stance")

func physics_process(_delta: float) -> void:
	# Transition to attack from stance
	if Input.is_action_just_pressed("attack"):
		player.enter_stance() # Resets the stance timer
		state_machine.transition("U_Attack1State")
		return
