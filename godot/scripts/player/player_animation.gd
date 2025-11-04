extends Node
@export var player : PlayerController
@export var animation_tree : AnimationTree
var animation_state
var playback: AnimationNodeStateMachinePlayback
# List of all possible conditions (same as those defined in the AnimationTree editor)
var all_states := ["idle_unsheath", "walk_unsheath", "run_unsheath", "attack","unsheathing","block",
"idle_sheath","walk_sheath","run_sheath", 
"hurt","die"]
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
		"idle_unsheath":
			set_animation_condition("idle")
		"walk_unsheath":
			set_animation_condition("walk")
		"run_unsheath":
			set_animation_condition("run")
		"attack":
			set_animation_condition("attack")
		"unsheathing":
			playback.travel("Unsheath")
		"block":
			playback.travel("Block")

		"idle_sheath":
			set_animation_condition("idle")
		"walk_sheath":
			set_animation_condition("walk")
		"run_sheath":
			set_animation_condition("run")

		"hurt":
			playback.travel("Hurt")
		"die":
			playback.travel("Die")

		_:
			set_animation_condition("idle") # fallback safe state

func set_animation_condition(active: String):
	for cond in all_conditions:
		animation_tree.set("parameters/conditions/%s" % cond, cond == active)
