class_name U_StanceState extends UpperBodyState

func get_state_name() -> String:
	return "U_StanceState"

func enter() -> void:
	player.U_anim_state = "U_StanceState"
	player.animation_tree.set("parameters/UpperBodyFSM/playback", "U_Stance")

func physics_process(_delta: float) -> void:
	if player._just_finished_attack:
		player._just_finished_attack = false
		return
	if Input.is_action_just_pressed("attack"):
		 # Resets the stance timer
		state_machine.transition("U_Attack1State")
		return
	elif  Input.is_action_just_pressed("Block"):
		state_machine.transition("U_BlockState")
		return
