extends Node
@export var player : PlayerController
@export var animation_tree : AnimationTree
var animation_state
var playback: AnimationNodeStateMachinePlayback
# List of all possible conditions (same as those defined in the AnimationTree editor)
var all_states := ["PlayerIdleState","PlayerMovementState","PlayerJumpState"
,"PlayerBlockState","PlayerAttackState","hurt","die"]
var all_conditions_sheath := ["run_sheath","sheathing","walk_sheath"]
var all_conditions_unsheath := ["attack","block","idle","run","unsheathing","walk"]
var sprinting
var sheath

func _ready():
	animation_tree.active = true
	playback = animation_tree.get("parameters/playback")
func enter() -> void:
	animation_state = player.animation_state
func _physics_process(delta):
	animation_state = player.animation_state
	sheath = player.is_sheathed
	sprinting = player.is_sprinting

	print(sheath)
	update_animation_state()
	
func update_animation_state():
	if sheath:
		match animation_state:
			"PlayerIdleState":
				set_sheath_animation_condition("sheathing")
			_:
				set_sheath_animation_condition("idle") # fallback safe state
	else:
		match animation_state:
			"PlayerIdleState":
				set_unsheath_animation_condition("idle")
			"PlayerMovementState":
				if sprinting:
					set_unsheath_animation_condition("run")
				else:
					set_unsheath_animation_condition("walk")
			"PlayerAttackState":
				set_unsheath_animation_condition("attack")
			#"unsheathing":
				#playback.travel("Unsheath")
			"PlayerBlockState":
				set_unsheath_animation_condition("block")

			#"idle_sheath":
				#set_animation_condition("idle")
			#"walk_sheath":
				#set_animation_condition("walk")
			#"run_sheath":
				#set_animation_condition("run")

			"hurt":
				playback.travel("Hurt")
			"die":
				playback.travel("Die")

			_:
				set_unsheath_animation_condition("idle") # fallback safe state

func set_sheath_animation_condition(active: String):
	animation_tree.set("parameters/conditions/sheath",true)
	animation_tree.set("parameters/conditions/unsheath",false)
	for cond in all_conditions_sheath:
		animation_tree.set("parameters/Sheath/conditions/%s" % cond, cond == active)

func set_unsheath_animation_condition(active: String):
	animation_tree.set("parameters/conditions/sheath",false)
	animation_tree.set("parameters/conditions/unsheath",true)
	for cond in all_conditions_unsheath:
		animation_tree.set("parameters/UnSheath/conditions/%s" % cond, cond == active)
		#print(active)
