class_name U_Attack1State extends UpperBodyState

var hitbox: AttackHitbox = player.attack1hitbox 

func get_state_name() -> String:
	return "U_Attack1State"

func enter() -> void:
	# Use "OneShot" to play the animation once and then transition automatically
	player.U_anim_state = "U_Attack1State"
	player.animation_tree.set("parameters/UpperBodyFSM/playback", "U_Attack1")
	
	# We wait for the animation to tell us when it's finished.
	# Connect to the signal in the AnimationTree (see Step 5).
	# In this example, we assume the AnimationTree will emit "animation_finished".
	# A robust way is to connect it once in the player's _ready function.
	# For now, let's assume the animation tree is set up to auto-advance.
	# See the note below.
	
	# A simple, less robust alternative is a timer:
	# await get_tree().create_timer(0.5).timeout # a crude way
	# if state_machine.current_state == self: # check if we weren't interrupted
	#     state_machine.transition("U_StanceState")
	
func physics_process(delta: float):
	# This state typically blocks further action input until the animation finishes.
	# The transition back to U_StanceState is handled by the AnimationTree.
	pass

func exit() -> void:
	# Clean up any attack logic if needed
	pass
