class_name PlayerDashState extends PlayerState

static var state_name = "PlayerDashState"
var timer:float = 0.0


func get_state_name() -> String:
	return state_name

func enter() -> void:
	timer= 0.0
	player.animation_state = state_name
	animationplayer.play("dash")
	# Only apply jump velocity if we are on the floor
	
	player.velocity.x = player.DASH_Velocity*player.horizontal_input

func physics_process(_delta: float) -> void:
	timer += _delta
	
	if timer>0.28:
		player.velocity.x = player.WALK_SPEED*player.horizontal_input
	
	
	player.handle_facing()
	if NarratorGlobal.is_narrating:
		state_machine.transition("PlayerDisableInputState")
	# Animation based on vertical velocity
	#if player.velocity.y < 0:
		#sprite2d.play("jump_up")
	#else:
		#sprite2d.play("jump_down")
	
	# Air control
