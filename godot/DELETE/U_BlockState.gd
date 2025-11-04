class_name U_BlockState extends UpperBodyState

func get_state_name() -> String:
	return "U_BlockState"

func enter() -> void:
	player.L_anim_state = "NULL" # this is to avoid overriding animations
	player.U_anim_state = "U_BlockState"


func physics_process(_delta: float) -> void:
	# Transition to attack directly from idle (draws weapon automatically)
	if Input.is_action_just_pressed("attack"):
		# This will handle the transition to Stance and Attack
		state_machine.transition("U_Attack1State")
		return

func exit():
	player.L_anim_state = "L_IdleState"
