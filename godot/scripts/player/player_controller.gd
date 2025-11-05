class_name PlayerController extends CharacterBody2D

enum Facing {
	LEFT,
	RIGHT
}

var horizontal_input: float = 0
var was_on_floor 
var _facing: Facing = Facing.RIGHT
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

#@onready var animatedsprite2d = $AnimatedSprite2D
@onready var animatedsprite2d: Sprite2D = $Sprite2D
@onready var movement_state_machine = $MovementStateMachine
@onready var action_state_machine = $ActionStateMachine
@onready var main_player = $".."
@export var jump_force:float = 400.0
@export var hurt_time :float =.5
@export var stun_time : float = .3 #Shopuld be less than hur5t time as I'm stunning in hurt state only
@export var is_friendly_scene:float = false
@export var unsheath_time:float = 10.0
#@onready var movement_state_machine = $MovementStateMachine
enum Animation_State{
	unsheath_idle,shealth_idle,walk,run,attak,hurt,die,interaction,block
}
var animation_state = "idle"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	
	var movement_states:Array[State] = [PlayerIdleState.new(self), PlayerMovementState.new(self), PlayerJumpState.new(self),PlayerHurtState.new(self),PlayerAttackState.new(self),PlayerParryState.new(self),PlayerBlockState.new(self)]
	#var action_states: Array[State] = []
	movement_state_machine.start_machine(movement_states)
	
	#action_state_machine.start_machine(action_states)

func _physics_process(delta: float) -> void:	
	horizontal_input = InputNode.horizontal_input()

	# Always apply gravity
	if not is_on_floor():
		velocity.y += _gravity * delta
		
	if not is_on_floor() and was_on_floor:
		movement_state_machine.transition("PlayerJumpState")

	was_on_floor = is_on_floor()
	move_and_slide()
	
	
func apply_knockback(knockback:Vector2):
	velocity = knockback
	
func taken_damage()->void:
	print("TakenDamage")
	movement_state_machine.transition("PlayerHurtState")
	
func handle_facing() -> void:
	var flip: int = 0
	
	if horizontal_input < 0.0:
		flip = 1
	elif horizontal_input > 0.0:
		flip = -1

	# Apply facing
	var _old_facing: Facing = _facing
	
	if flip == -1:
		animatedsprite2d.flip_h = false
		_facing = Facing.RIGHT
	elif flip == 1:
		animatedsprite2d.flip_h = true
		_facing = Facing.LEFT	
		
		
