# Player.gd

extends CharacterBody2D

# ... (export variables for speed, etc.)

@onready var anim_tree = $AnimationTree
@onready var lower_body_fsm = anim_tree.get("parameters/LowerBodyFSM/playback")
@onready var upper_body_fsm = anim_tree.get("parameters/UpperBodyFSM/playback")

func _physics_process(delta):
	# --- Handle Input and Movement ---
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * 10
	move_and_slide()

	# --- Update Animation Tree ---
	update_animation_parameters()

func update_animation_parameters():
	# --- Control the Lower Body State Machine ---

	if velocity.x == 0:
		lower_body_fsm.travel("Idle")
	else:
		upper_body_fsm.travel("Shoot")
			# Flip sprites based on direction
		$lower.flip_h = velocity.x < 0
		$upper.flip_h = velocity.x < 0
	# Add jump/fall animation logic here later

	# --- Control the Upper Body State Machine ---
	if Input.is_action_pressed("ui_page_down"):
		upper_body_fsm.travel("Shoot")
	else:
		# Only go back to idle if not already in idle
		# to avoid interrupting the shoot animation
		if upper_body_fsm.get_current_node() == "Shoot":
			upper_body_fsm.travel("Idle")
