extends Node
@export var Player : PlayerControllerTest
@export var animation_tree : AnimationTree
var Upper_anim_state
var Lower_anim_state
var playback: AnimationNodeStateMachinePlayback
# List of all possible conditions (same as those defined in the AnimationTree editor)
var lower_states := ["L_Idle", "L_Run","L_Jump"]
var upper_states := ["U_Idle", "U_Stance","U_Attack1"]
#var all_conditions := ["idle","walk", "run", "attack1", "attack2","jump"]

func _ready():
	animation_tree.active = true
	#playback = animation_tree.get("parameters/playback")
	
func enter() -> void:
	Upper_anim_state = Player.U_anim_state
	Lower_anim_state = Player.L_anim_state
func _physics_process(delta):
	Upper_anim_state = Player.U_anim_state
	Lower_anim_state = Player.L_anim_state
	#print(animation_state)
	update_animation_state()
	
func update_animation_state():
	match Upper_anim_state:
		"U_IdleState":
			set_upper_anim("U_Idle")
		"U_StanceState":
			set_upper_anim("U_Stance")
		"U_Attack1State":
			set_upper_anim("U_Attack1")
	match Lower_anim_state:
		"L_IdleState":
			set_lower_anim("L_Idle")

		#"attack2":
			#set_animation_condition("attack2")
		#"jump":
			#set_animation_condition("jump")##Remember to add to all-conditions
		#"hurt":
			#animation_tree.set("parameters/StateMachine/current", "Hurt")
		#"die":
			#animation_tree.set("parameters/StateMachine/current", "Die")
		#_:
			# Optional: default fallback
			#set_animation_condition("idle")

func set_lower_anim(active: String):
	for cond in lower_states:
		animation_tree.set("parameters/LowerBodyFSM/conditions/%s" % cond, cond == active)

func set_upper_anim(active: String):
	for cond in upper_states:
		animation_tree.set("parameters/UpperBodyFSM/conditions/%s" % cond, cond == active)
