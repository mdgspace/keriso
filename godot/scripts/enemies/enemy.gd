class_name Enemy extends CharacterBody2D

@export var max_health =100;
@export var walk_speed =45;
@export var run_speed = 100;
@export var jump_force =350;
@export var near_detection_range= 250;
@export var far_detection_range = 500;
@export var attack_range = 100;
@export var attack_cooldown = 1
enum Facing {
	LEFT,
	RIGHT
}

var horizontal_input: float = 0
var was_on_floor 
var _facing: Facing = Facing.RIGHT
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

signal anim_finished
@onready var animatedplayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var movement_state_machine = $MovementStateMachine
@onready var action_state_machine = $ActionStateMachine
@onready var low_ray1 = $LeftRayCast2D
@onready var low_ray2 = $RightRayCast2D
@onready var down_ray1 = $DownLeftRayCast2D
@onready var down_ray2 = $DownRightRayCast2D
@onready var player_ray1 = $PlayerRayCast2D
@onready var player_ray2 = $PlayerRayCast2D3
@export var player_path: NodePath
var low_collision:bool
var down_collision:bool
var player_position: Vector2
var player: Node2D
var to_player: Vector2 = Vector2.ZERO;
func _ready() -> void:
	player = get_node(player_path)
	var movement_states: Array[State] = [EnemyIdleState.new(self), EnemyRoamState.new(self), EnemyJumpState.new(self),
	 EnemyFollowState.new(self),EnemyJumpDownState.new(self),EnemyAttack1State.new(self),EnemyAttack2State.new(self)]
	var action_states: Array[State] = [EnemyNoneState.new(self),EnemyAttack1State.new(self),EnemyAttack2State.new(self)]
	movement_state_machine.start_machine(movement_states)
	action_state_machine.start_machine(action_states)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
	print(scale.x)
	flip_area()
	##Jump Up And flip
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
	player_position = player.global_position
	to_player = player.global_position - global_position
	move_and_slide()

func jump():
	velocity.y = -jump_force

func flip_area()-> void:
	if _facing == Facing.RIGHT:
		low_ray1.scale.x = abs(low_ray1.scale.x)

func can_see_player() -> bool:
	if not is_instance_valid(player):
		return false
	
	var distance = to_player.length()

	#if distance > far_detection_range:
		#return false
	if player_ray1.is_colliding() || player_ray2.is_colliding():
		return true
	#if distance < near_detection_range:
		#return true
	#
	#if _facing==Facing.RIGHT && to_player.x<0:
		#return false
	#if _facing==Facing.LEFT && to_player.x>0:
		#return false
	#
##TODO:Have to do a check for player

	return false

func flip():
	scale.x = -scale.x

func set_facing_direction(direction: float) -> void:
	print(direction)
	if direction > 0:
		_facing = Facing.RIGHT
		scale.x = abs(scale.x)
	elif direction < 0:
		_facing = Facing.LEFT
		scale.x = -abs(scale.x)

func handle_facing() -> void:
	#print("calling handle facing")
	var intended_direction: float = 0.0
	
	# Priority 1: Use player direction if player is visible and close
	if has_method("can_see_player") and can_see_player():
		if abs(to_player.x) > 10.0:  # Only if player is not directly above/below
			intended_direction = sign(to_player.x)
	
	# Priority 2: Use velocity direction if moving
	if intended_direction == 0.0 and abs(velocity.x) > 0.1:
		intended_direction = sign(velocity.x)
	
	# Priority 3: Keep current facing if no clear direction (idle state)
	if intended_direction == 0.0:
		return  # Don't change facing
	
	# Apply facing change
	var new_facing: Facing = Facing.RIGHT if intended_direction > 0 else Facing.LEFT
	
	if new_facing != _facing:
		_facing = new_facing
		
		# Flip the entire node
		if _facing == Facing.LEFT:
			scale.x = -abs(scale.x)
		else:
			scale.x = abs(scale.x)
