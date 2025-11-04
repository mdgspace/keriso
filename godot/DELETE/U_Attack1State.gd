class_name U_Attack1State extends UpperBodyState

var ani_player : AnimationPlayer

func get_state_name() -> String:
	return "U_Attack1State"

func enter() -> void:
	# Use "OneShot" to play the animation once and then transition automatically

	
	player.U_anim_state = "U_Attack1State"
	player.animation_tree.set("parameters/UpperBodyFSM/playback", "U_Attack1")
	ani_player = player.get_node("AnimationPlayer")
	#_on_animation_player_animation_finished("U_Attack1").connect(_on_animation_finished())

	
func physics_process(delta: float):
	# This state typically blocks further action input until the animation finishes.
	# The transition back to U_StanceState is handled by the AnimationTree.
	if  Input.is_action_just_pressed("Block"):
		state_machine.transition("U_BlockState")
		return

func exit() -> void:
	player._just_finished_attack = true
	player.enter_stance()
	# clear hit target done in animation tree

func _on_animation_finished():
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
