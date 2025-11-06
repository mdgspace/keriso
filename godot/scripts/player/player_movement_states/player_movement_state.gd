
class_name PlayerMovementState extends PlayerState

static var state_name = "PlayerMovementState"
const WALK_ACCELERATION: float = 1000.0
const RUN_ACCELERATION: float = 1400.0

func get_state_name() -> String:
	return state_name

func enter():
	player.animation_state = state_name

func process(_delta: float) -> void:
	# Check for action inputs
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition("PlayerJumpState")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition("PlayerAttackState")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition("PlayerBlockState")

func physics_process(delta: float) -> void:
	player.handle_facing()

	var current_speed: float
	var current_accel: float

	# Choose speed and animation based on sprint input
	if player.is_sprinting:
		current_speed = player.RUN_SPEED
		current_accel = RUN_ACCELERATION
	else:
		current_speed = player.WALK_SPEED
		current_accel = WALK_ACCELERATION
	
	
	# Process movement
	var target_speed = player.horizontal_input * current_speed
	player.velocity.x = move_toward(player.velocity.x, target_speed, current_accel * delta)

	# Check for transition back to idle
	if player.horizontal_input == 0.0:
		state_machine.transition("PlayerIdleState")
