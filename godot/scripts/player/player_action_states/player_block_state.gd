class_name PlayerBlockState extends PlayerState

static var state_name = "PlayerBlockState"
const STOP_FORCE: float = 1000.0

func get_state_name() -> String:
	return state_name

func enter() -> void:
	player.animation_state = state_name
	player.is_sheathed = false
	player.start_sheath_timer()
	player.hurtbox.is_invincible = true
	#animatedsprite2d.play("block")

#func process(_delta: float) -> void:
	# Exit state when block button is released
	#if Input.is_action_just_released("block"):
		#state_machine.transition("PlayerIdleState")

func physics_process(delta: float) -> void:
	# Prevent player from sliding while blocking
	player.velocity.x = move_toward(player.velocity.x, 0, STOP_FORCE * delta)

func exit() -> void:
	player.hurtbox.is_invincible = false
