class_name PlayerController extends CharacterBody2D

# --- State & Input ---
@onready var state_machine: StateMachine = $StateMachine

#@onready var animatedsprite2d: AnimatedSprite2D = $AnimatedSprite2D # Use AnimatedSprite2D for easier animation control
@onready var animatedsprite2d: Sprite2D = $Sprite2D
@onready var hurtbox = $Hurtbox
@onready var unsheath_timer = $UnsheathTimer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var attack_hit_box: AttackHitBox = $AttackHitBox
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var horizontal_input: float = 0.0
var is_sprinting: bool = false
var is_sheathed: bool = true
var animation_state = "idle"
# --- Physics & Movement ---
const WALK_SPEED: float = 150.0
const RUN_SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
const DASH_Velocity:float = 800.0
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	# We now have one FSM for everything.
	var states: Array[State] = [
		PlayerIdleState.new(self),
		PlayerMovementState.new(self),
		PlayerJumpState.new(self),
		PlayerAttackState.new(self),
		PlayerHeavyAttackState.new(self),
		PlayerDashState.new(self),
		PlayerBlockState.new(self), # Don't forget the Hurt state
		PlayerDisableInputState.new(self)
	]
	state_machine.start_machine(states)
	#unsheath_timer.timeout.connect(_on_unsheath_timer_timeout)
	

func _get_input() -> void:
	# Central place to get all input for the frame.
	horizontal_input = Input.get_axis("move_left", "move_right")
	# Assumes a "sprint" action is mapped (e.g., to Shift key)
	is_sprinting = Input.is_action_pressed("sprint")
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("block"):
		start_sheath_timer()
	#unsheath_timer.timeout.connect(_on_unsheath_timer_timeout)

func _physics_process(delta: float) -> void:    
	_get_input()
	#print(is_sheathed)
	# Always apply gravity
	if not is_on_floor():
		velocity.y += _gravity * delta

	if Input.is_action_just_pressed("interact"):
		ray_cast_2d.enabled = true
		ray_cast_2d.force_raycast_update()

		if ray_cast_2d.is_colliding():
			var target = ray_cast_2d.get_collider().get_parent()

			if target and target.has_method("interact"):
				target.interact()

		# Disable immediately so it doesn't keep firing
		ray_cast_2d.enabled = false

	# The current state will handle velocity and transitions.
	move_and_slide()

# --- Public Functions for States ---
func handle_facing() -> void:
	if horizontal_input > 0.0:
		animatedsprite2d.flip_h = true
		ray_cast_2d.scale = -abs(ray_cast_2d.scale)
		attack_hit_box.scale = -abs(attack_hit_box.scale)
	elif horizontal_input < 0.0:
		animatedsprite2d.flip_h = false
		ray_cast_2d.scale = abs(ray_cast_2d.scale)
		attack_hit_box.scale = abs(attack_hit_box.scale)

func start_sheath_timer() -> void:
	is_sheathed = false
	unsheath_timer.start()

func _on_unsheath_timer_timeout() -> void:
	is_sheathed = true
	# If we are currently in Idle, force an animation refresh
	if state_machine.current_state.get_state_name() == "PlayerIdleState":
		state_machine.current_state.enter() 

# --- Damage & Knockback ---
func apply_knockback(knockback: Vector2) -> void:
	velocity = knockback
	

	
func change_state(state:String):
	state_machine.transition(state)
