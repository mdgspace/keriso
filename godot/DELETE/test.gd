
extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var lower_body_fsm = anim_tree.get("parameters/LowerBodyFSM/playback")
@onready var upper_body_fsm = anim_tree.get("parameters/UpperBodyFSM/playback")

# Define all valid conditions
var lower_conditions = ["Idle_lower", "Attack_lower"]
var upper_conditions = ["Idle_upper", "Attack_upper"]

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * 200
	move_and_slide()

	update_animation_parameters()

func update_animation_parameters():
	# Flip sprites
	if velocity.x != 0:
		$lower.flip_h = velocity.x > 0
		$upper.flip_h = velocity.x > 0

	# Lower body FSM
	if velocity.x == 0:
		set_lower_anim("Idle_lower")
	else:
		set_lower_anim("Attack_lower")

	# Upper body FSM
	if Input.is_action_pressed("ui_page_down"):
		set_upper_anim("Attack_upper")
	else:
		set_upper_anim("Idle_upper")

func set_lower_anim(active: String):
	for cond in lower_conditions:
		anim_tree.set("parameters/LowerBodyFSM/conditions/%s" % cond, cond == active)

func set_upper_anim(active: String):
	for cond in upper_conditions:
		anim_tree.set("parameters/UpperBodyFSM/conditions/%s" % cond, cond == active)
