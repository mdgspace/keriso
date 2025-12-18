
class_name PlayerAttackState extends PlayerState

static var state_name = "PlayerAttackState"
const ATTACK_DURATION = 0.5 # Duration of the attack animation
const STOP_FORCE: float = 1000.0


func get_state_name() -> String:
	return state_name


func enter() -> void:
	player.animation_state = state_name

	#player.reset_sheath_timer()
	#animatedsprite2d.play("attack")
	# You would enable your hitbox here

	# Wait for the attack to finish
	#await get_tree().create_timer(ATTACK_DURATION).timeout
	#
	## Transition out if we are still in the attack state
	#if state_machine.current_state == self:
		#state_machine.transition("PlayerIdleState")

func physics_process(delta: float) -> void:
	# Prevent player from sliding during attack
	player.velocity.x = move_toward(player.velocity.x, 0, STOP_FORCE * delta)
	if NarratorGlobal.is_narrating:
		state_machine.transition("PlayerDisableInputState")

func exit() -> void:
	# You would disable your hitbox here
	pass
