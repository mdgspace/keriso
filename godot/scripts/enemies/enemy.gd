class_name Enemy extends CharacterBody2D


enum Facing {
	LEFT,
	RIGHT
}

var horizontal_input: float = 0
var was_on_floor 
var _facing: Facing = Facing.RIGHT
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animatedsprite2d = $AnimatedSprite2D
@onready var state_machine = $StateMachine
#@onready var movement_state_machine = $MovementStateMachine

func _ready() -> void:
	var states: Array[State] = [EnemyIdleState.new(self), EnemyRoamState.new(self), EnemyJumpState.new(self),EnemyFollowState.new(self),EnemyAttackState.new(self)]
	state_machine.start_machine(states)

func _physics_process(delta: float) -> void:	
	# Always apply gravity
	if not is_on_floor():
		velocity.y += _gravity * delta
		
	if not is_on_floor() and was_on_floor:
		state_machine.transition("PlayerJumpState")

	was_on_floor = is_on_floor()
	
func handle_facing() -> void:
	var flip: int = 0
	
	if velocity.x < 0.0:
		flip = 1
	elif velocity.x > 0.0:
		flip = -1

	# Apply facing
	var _old_facing: Facing = _facing
	
	if flip == -1:
		animatedsprite2d.flip_h = false
		_facing = Facing.RIGHT
	elif flip == 1:
		animatedsprite2d.flip_h = true
		_facing = Facing.LEFT	
