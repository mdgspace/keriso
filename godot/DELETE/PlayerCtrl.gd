# PlayerController.gd
class_name PlayerControllerTest extends CharacterBody2D

# --- SHARED VARIABLES (For all states to access) ---
var horizontal_input: float = 0
var is_in_stance: bool = false
const STANCE_DURATION: float = 10.0 # Seconds before exiting stance

const JUMP_VELOCITY: float = -1500.0
const MAX_SPEED: float = 150.0
enum Facing {
	LEFT,
	RIGHT
}
var _facing: Facing = Facing.RIGHT
var U_anim_state = "U_IdleState"
var L_anim_state = "L_IdleState"
var _just_finished_attack = false # to manage input buffering

@onready var lower_fsm = $LowerStateMachine
@onready var upper_fsm = $UpperStateMachine
@onready var stance_timer = $StanceTimer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var upper: Sprite2D = $upper
@onready var lower: Sprite2D = $lower
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_1_hitbox: AttackHitbox = $Attack1Hitbox
@onready var playerboundary: CollisionShape2D = $Attack1Hitbox/CollisionShape2D

func _ready() -> void:
	# Set the AnimationTree to active so it controls animations
	animation_tree.active = true

	# --- Lower Body (Movement) States ---
	var lower_states: Array[State] = [
		L_IdleState.new(self),
		L_RunState.new(self),
		L_JumpState.new(self),
		#L_HurtState.new(self),
		# Add L_HurtState, L_BlockState here later
	]
	lower_fsm.start_machine(lower_states)

	# --- Upper Body (Action) States ---
	var upper_states: Array[State] = [
		U_IdleState.new(self),
		U_StanceState.new(self),
		U_Attack1State.new(self),
		U_BlockState.new(self)
		# Add U_Attack2State here later
	]
	upper_fsm.start_machine(upper_states)
	
	stance_timer.wait_time = STANCE_DURATION
	stance_timer.one_shot = true
	stance_timer.timeout.connect(_on_stance_timer_timeout)

func _physics_process(delta: float) -> void:
	# 1. Get input
	horizontal_input = Input.get_axis("move_left", "move_right")
	# 2. Apply global physics (Gravity)
	if not is_on_floor():
		velocity.y += 4*ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# 3. The FSMs do their work in their own _physics_process calls.
	#    The Lower FSM will update velocity for us.

	# 4. Apply final movement
	move_and_slide()
	_update_sprite_stitching()
# --- Public Functions for States to Call ---

# This function is called by the PlayerHurtbox
func apply_knockback(force: Vector2) -> void:
	self.velocity = force

func UBody_transition_to_state(state:String)-> void:
	upper_fsm.transition(state)
# This function is called by the PlayerHurtbox to trigger the FSM
func taken_damage() -> void:
	# Getting hurt affects movement, so we tell the Lower FSM to change state
	lower_fsm.transition("L_HurtState")

func handle_facing() -> void:
	var flip: int = 0
	
	if horizontal_input < 0.0:
		flip = 1
	elif horizontal_input > 0.0:
		flip = -1

	
	if flip == -1:
		upper.flip_h = true
		lower.flip_h = true
		playerboundary.position = Vector2(13.6,-26.2)
		_facing = Facing.RIGHT
	elif flip == 1:
		playerboundary.position = Vector2(-20.2,-26.2)
		upper.flip_h = false
		lower.flip_h = false
		_facing = Facing.LEFT

func enter_stance() -> void:
	if not is_in_stance:
		is_in_stance = true
		upper_fsm.transition("U_StanceState")
	stance_timer.start() # Reset timer every time we do something in stance

func _on_stance_timer_timeout():
	is_in_stance = false
	upper_fsm.transition("U_IdleState")


#-------Stitching logic
const LowerIdleMatching : Dictionary = {
	"U_IdleState": Vector2(245, 232),
	"U_StanceState": Vector2(244, 229),
	"U_Attack1State": Vector2(243, 224)
}

const LowerRunMatching : Dictionary = {
	"U_IdleState": Vector2(245, 236),
	"U_StanceState": Vector2(245, 233),
	"U_Attack1State": Vector2(242, 227)
}

var general_positions :Dictionary = {"U_BlockState":Vector2(245,232)}

func _update_sprite_stitching() -> void:
	var current_lower_state_name = lower_fsm.current_state.get_state_name()
	var current_upper_state_name = upper_fsm.current_state.get_state_name()
	
	if current_upper_state_name == "U_BlockState":

		lower.position = general_positions["U_BlockState"]

	match current_lower_state_name:
		"L_IdleState":
			if LowerIdleMatching.has(current_upper_state_name):
				lower.position = LowerIdleMatching[current_upper_state_name]
		"L_RunState":
			if LowerRunMatching.has(current_upper_state_name):
				lower.position = LowerRunMatching[current_upper_state_name]
