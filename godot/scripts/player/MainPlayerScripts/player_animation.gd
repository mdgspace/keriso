extends Node
@export var player : PlayerController
@export var animation_tree : AnimationTree
var animation_state
var playback: AnimationNodeStateMachinePlayback
# List of all possible conditions (same as those defined in the AnimationTree editor)
var all_states := ["PlayerIdleState","PlayerMovementState","PlayerJumpState"
,"PlayerBlockState","PlayerAttackState","PlayerHeavyAttackState","PlayerDashState","hurt","die"]
var all_conditions_sheath := ["idle_sheath","run_sheath","walk_sheath","dash"]#"sheathing"
var all_conditions_unsheath := ["attack","block","idle","run","walk","dash"]#"unsheathing"
var all_conditions := ["idle_sheath","run_sheath","walk_sheath","attack","heavyattack","dash","block","idle","run","walk"]
var sprinting
var sheath

func _ready():
	animation_tree.active = true
	playback = animation_tree.get("parameters/playback")
func enter() -> void:	
	animation_state = player.animation_state
func _physics_process(_delta):
	animation_state = player.animation_state
	sheath = player.is_sheathed
	sprinting = player.is_sprinting
	#print(animation_state)

	update_animation_state()
	
func update_animation_state():
	if sheath:
		match animation_state:
			"PlayerIdleState":
				set_sheath_animation_condition("idle_sheath")
				#set_sheath_animation_condition("sheathing")
			"PlayerMovementState":
				if sprinting:
					set_sheath_animation_condition("run_sheath")
				else:
					set_sheath_animation_condition("run_sheath")
			"PlayerDashState":
				set_unsheath_animation_condition("dash")
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
			"PlayerDashState":
				set_unsheath_animation_condition("dash")
			"PlayerAttackState":
				set_unsheath_animation_condition("attack")
			"PlayerHeavyAttackState":
				set_unsheath_animation_condition("heavyattack")
			#"unsheathing":
				#playback.travel("Unsheath")
			"PlayerBlockState":
				set_unsheath_animation_condition("block")

			#"hurt":
				#playback.travel("Hurt")
			#"die":
				#playback.travel("Die")

			_:
				set_unsheath_animation_condition("idle") # fallback safe state

func set_sheath_animation_condition(active: String):
	animation_tree.set("parameters/conditions/sheathing",true)
	animation_tree.set("parameters/conditions/unsheathing",false)
	for cond in all_conditions:
		animation_tree.set("parameters/conditions/%s" % cond, cond == active)

func set_unsheath_animation_condition(active: String):
	animation_tree.set("parameters/conditions/sheathing",false)
	animation_tree.set("parameters/conditions/unsheathing",true)
	for cond in all_conditions:
		animation_tree.set("parameters/conditions/%s" % cond, cond == active)
