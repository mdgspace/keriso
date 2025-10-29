class_name PlayerJumpState extends PlayerState


static var state_name = "PlayerJumpState"


const JUMP_MAX_FORCE: float = 1500.0;
#const JUMP_TOP_ANIM_THRESHOLD: float = 60.0

const ACCELERATION: float = 20
const MAX_SPEED: float = 120
const STOP_FORCE: float = 5

var _is_jumping: float = false


func get_state_name() -> String:
	return state_name
	

func enter() -> void:
	if player.is_on_floor():
		player.velocity.y = -player.jump_force
		
	_is_jumping = true
	
	
func exit() -> void:
	_is_jumping = false
	
	
func process(_delta: float) -> void:
	# Handle animation
	#var anim: String
	#if player.velocity.y < -JUMP_TOP_ANIM_THRESHOLD:
		#anim = "jump_up"
	#else:
		#anim = "jump_down"
	#animatedsprite2d.play(anim)
	if player.velocity.x == 0:
		animatedsprite2d.play("idle")
	else:
		animatedsprite2d.play("run") 
	player.handle_facing()
	
	
func physics_process(_delta: float) -> void:
	var input: float = player.horizontal_input * ACCELERATION
	
	# Detect touching the ground to stop state
	if player.is_on_floor() and _is_jumping:
		print("touch floor")
		if input == 0.0:
			movement_state_machine.transition(PlayerIdleState.state_name)
		else:
			movement_state_machine.transition(PlayerMovementState.state_name)
		pass
		
	# Process movement while on air
	if abs(input) < ACCELERATION * 0.2:
		player.velocity.x = move_toward(player.velocity.x, 0, STOP_FORCE)
	else:
		player.velocity.x += input
		
	player.velocity.x = clamp(player.velocity.x, -MAX_SPEED, MAX_SPEED)
