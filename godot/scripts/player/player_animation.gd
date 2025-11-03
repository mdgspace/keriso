extends Node
@export var player : PlayerController
@export var animation_tree : AnimationTree
var animation_state
var playback: AnimationNodeStateMachinePlayback
# List of all possible conditions (same as those defined in the AnimationTree editor)
var all_states := ["idle", "walk", "run", "attack1", "attack2", 
"hurt","jump","jumpdown","die"]
var all_conditions := ["idle","walk", "run", "attack1", "attack2","jump"]

func _ready():
	animation_tree.active = true
	playback = animation_tree.get("parameters/playback")
	
func enter() -> void:
	animation_state = player.animation_state
func _physics_process(delta):
	animation_state = player.animation_state
	#print(animation_state)
	update_animation_state()
	
func update_animation_state():
	match animation_state:
		"unsheath_idle":
			set_animation_condition("idle")
		"sheath_idle":
			set_animation_condition("idle")
		"walk":
			set_animation_condition("walk")
		"run":
			set_animation_condition("run")
		"attack1":
			set_animation_condition("attack1")
		#"jump":
			#set_animation_condition("jump")##Remember to add to all-conditions
		"hurt":
			animation_tree.set("parameters/StateMachine/current", "Hurt")
		"die":
			animation_tree.set("parameters/StateMachine/current", "Die")
		_:
			# Optional: default fallback
			set_animation_condition("unsheath_idle")

func set_animation_condition(active: String):
	for cond in all_conditions:
		animation_tree.set("parameters/conditions/%s" % cond, cond == active)
