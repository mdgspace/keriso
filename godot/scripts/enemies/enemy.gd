class_name Enemy extends CharacterBody2D

@export var max_health =100;
@export var walk_speed =30;
@export var run_speed = 50;
@export var jump_force =50;
@export var near_detection_range= 250;
@export var far_detection_range = 500;
@export var attack_range = 100;
enum Facing {
	LEFT,
	RIGHT
}

var horizontal_input: float = 0
var was_on_floor 
var _facing: Facing = Facing.RIGHT
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animatedsprite2d = $AnimatedSprite2D
@onready var movement_state_machine = $MovementStateMachine
@onready var action_state_machine = $ActionStateMachine
@onready var low_ray1 = $LeftRayCast2D
@onready var low_ray2 = $RightRayCast2D
@onready var down_ray1 = $DownLeftRayCast2D
@onready var down_ray2 = $DownRightRayCast2D
@onready var player_ray = $PlayerRayCast2D
@export var player_path: NodePath
var low_collision:bool
var down_collision:bool
var player: Node2D
var to_player: Vector2 = Vector2.ZERO;
func _ready() -> void:
	player = get_node(player_path)
	var movement_states: Array[State] = [EnemyIdleState.new(self), EnemyRoamState.new(self), EnemyJumpState.new(self), EnemyFollowState.new(self),EnemyJumpDownState.new(self)]
	var action_states: Array[State] = [EnemyAttack1State.new(self)]
	movement_state_machine.start_machine(movement_states)
	action_state_machine.start_machine(action_states)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
	##Jump Up
	if (low_ray1.is_colliding()||low_ray2.is_colliding()):
		low_collision = true
	else :
		low_collision = false
	##Jump Down
	if(down_ray1.is_colliding()&&down_ray2.is_colliding()):
		down_collision = true
	else:
		down_collision = false
	was_on_floor = is_on_floor()
	
	to_player = player.global_position - global_position
	move_and_slide()

func jump():
	velocity.y = -220

func can_see_player() -> bool:
	if not is_instance_valid(player):
		return false
	
	var distance = to_player.length()

	if distance > far_detection_range:
		return false
	player_ray.target_position = to_player
	player_ray.force_raycast_update()
	if distance < near_detection_range:
		return player_ray.is_colliding()
	
	if _facing==Facing.RIGHT && to_player.x<0:
		return false
	if _facing==Facing.LEFT && to_player.x>0:
		return false
	
##TODO:Have to do a check for player

	return player_ray.is_colliding() 

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
