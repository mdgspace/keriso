
class_name PlayerJumpState extends PlayerState

static var state_name = "PlayerJumpState"
const AIR_ACCELERATION: float = 800.0


func get_state_name() -> String:
	return state_name

func enter() -> void:
	player.animation_state = state_name
	# Only apply jump velocity if we are on the floor
	if player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY

func physics_process(delta: float) -> void:
	player.handle_facing()
	if NarratorGlobal.is_narrating:
		state_machine.transition("PlayerDisableInputState")
	# Animation based on vertical velocity
	#if player.velocity.y < 0:
		#sprite2d.play("jump_up")
	#else:
		#sprite2d.play("jump_down")

	# Air control
	var target_speed = player.horizontal_input * player.WALK_SPEED # Use walk speed for air control
	player.velocity.x = move_toward(player.velocity.x, target_speed, AIR_ACCELERATION * delta)

	# Detect landing to exit state
	if player.is_on_floor() and player.velocity.y >= 0:
		if player.horizontal_input == 0.0:
			state_machine.transition("PlayerIdleState")
		else:
			state_machine.transition("PlayerMovementState")
