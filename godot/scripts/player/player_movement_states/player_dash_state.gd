class_name PlayerDashState extends PlayerState

static var state_name = "PlayerDashState"
const Dash_ACCELERATION: float = 800.0


func get_state_name() -> String:
	return state_name

func enter() -> void:
	player.animation_state = state_name
	# Only apply jump velocity if we are on the floor
	
	player.velocity.x = player.DASH_velocity*player.horizontal_input

func physics_process(_delta: float) -> void:
	player.handle_facing()
	if NarratorGlobal.is_narrating:
		state_machine.transition("PlayerDisableInputState")
	# Animation based on vertical velocity
	#if player.velocity.y < 0:
		#sprite2d.play("jump_up")
	#else:
		#sprite2d.play("jump_down")

	# Air control
	# Detect landing to exit state
	if player.is_on_floor() and player.velocity.y >= 0:
		if player.horizontal_input == 0.0:
			state_machine.transition("PlayerIdleState")
		else:
			state_machine.transition("PlayerMovementState")
