# PlayerController.gd
class_name PlayerControllerTest extends CharacterBody2D

# --- SHARED VARIABLES (For all states to access) ---
var horizontal_input: float = 0
var is_in_stance: bool = false
const STANCE_DURATION: float = 10.0 # Seconds before exiting stance

const JUMP_VELOCITY: float = -400.0
const MAX_SPEED: float = 150.0
enum Facing {
	LEFT,
	RIGHT
}
var _facing: Facing = Facing.RIGHT
var U_anim_state = "U_IdleState"
var L_anim_state = "L_IdleState"

@onready var lower_fsm = $LowerStateMachine
@onready var upper_fsm = $UpperStateMachine
@onready var stance_timer = $StanceTimer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var upper: Sprite2D = $upper
@onready var lower: Sprite2D = $lower
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_1_hitbox: AttackHitbox = $Attack1Hitbox

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
		U_Attack1State.new(self)
		# Add U_Attack2State here later
	]
	upper_fsm.start_machine(upper_states)
	
	stance_timer.wait_time = STANCE_DURATION
	stance_timer.one_shot = true
	stance_timer.timeout.connect(_on_stance_timer_timeout)

func _physics_process(delta: float) -> void:
	# 1. Get input
	horizontal_input = Input.get_axis("ui_left", "ui_right")

	# 2. Apply global physics (Gravity)
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# 3. The FSMs do their work in their own _physics_process calls.
	#    The Lower FSM will update velocity for us.

	# 4. Apply final movement
	move_and_slide()

# --- Public Functions for States to Call ---

# This function is called by the PlayerHurtbox
func apply_knockback(force: Vector2) -> void:
	self.velocity = force

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

	# Apply facing
	var _old_facing: Facing = _facing
	
	if flip == -1:
		upper.flip_h = true
		lower.flip_h = true
		_facing = Facing.RIGHT
	elif flip == 1:
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
