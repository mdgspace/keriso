class_name PlayerIdleState extends PlayerState


static var state_name = "PlayerIdleState"

const STOP_FORCE: float = 15
var timer:float =0.0

func enter() -> void:
	player.animation_state = state_name
	timer =0.0

func process(_delta: float) -> void:
	if NarratorGlobal.is_narrating:
		state_machine.transition("PlayerDisableInputState")
	if InputNode.is_just_pressed("jump"):
		state_machine.transition(PlayerJumpState.state_name)
		pass
		
	#if InputNode.is_just_pressed("attack"):
		#state_machine.transition(PlayerAttackState.state_name)
		#pass

	if InputManagerInstance.was_action_held_for("attack", 30):
		print("HEAVY ATTACK triggered!")
		state_machine.transition("PlayerHeavyAttackState")

# This will only be	 checked if the heavy attack condition wasn't met.
	elif InputManagerInstance.was_short_press_released("attack"):
		print("LIGHT ATTACK triggered!")
		state_machine.transition("PlayerAttackState")


	elif Input.is_action_just_pressed("block"):
		state_machine.transition("PlayerBlockState")
		
	#if timer>player.unsheath_timer.get_time_left():
		#player.animation_state = "unsheath_idle"
	#else:
		#player.animation_state = "sheath_idle"
		
	player.handle_facing()


func physics_process(_delta: float) -> void:
	timer+=_delta
	if player.horizontal_input != 0.0:
		print("going to move state")
		state_machine.transition(PlayerMovementState.state_name)

	#print(player.horizontal_input)
	
	# Apply stop force if it's movingdada
	if player.velocity.x != 0.0:
		player.velocity.x = move_toward(player.velocity.x, 0, STOP_FORCE)
		
		
func get_state_name() -> String:
	return state_name
