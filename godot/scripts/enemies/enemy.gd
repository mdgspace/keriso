class_name Enemy extends CharacterBody2D

@export var max_health =100;
@export var walk_speed =60;
@export var run_speed = 100;
@export var jump_force =350;
@export var near_detection_range= 60;
@export var far_detection_range = 200;
@export var attack_range = 60;
@export var attack_cooldown = 0.5
@export var seen_player_timer:float =10
enum Facing {
	LEFT,
	RIGHT
}
enum Animation_State{
	idle,walk,run,attak1,attack2,jump,jumpdown,hurt,die
}
var animation_state = "idle"
var horizontal_input: float = 0
var was_on_floor 
var _facing: Facing = Facing.RIGHT
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animatedplayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var movement_state_machine = $MovementStateMachine
@onready var action_state_machine = $ActionStateMachine
###Flip Objects
@onready var low_ray1 = $RightRayCast2D
@onready var down_ray1 = $DownRightRayCast2D
##fov
@onready var player_ray1 = $PlayerRayCast2D
@onready var player_ray2 = $PlayerRayCast2D3
@export var Attack1Hitbox: Area2D
@export var Attack2Hitbox: Area2D

var dash_speed := 1000.0
var dash_duration := 0.15
#to tackle distace =9 for 1 sec bug 
var timer := 0.00
var condition  = false

var dash_vector: int =1
var dash_timer: float = 0.0
var is_dashing: bool = false

var low_collision:bool
var down_collision:bool
var player_position: Vector2
var player 
var to_player: Vector2 = Vector2.ZERO;


var follow_end_timer: float = 50.0

func _ready() -> void:
	while PlayerGlobal.player_instance == null:
		await get_tree().process_frame
	while PlayerGlobal.player_instance.CharacterBody == null:
		await get_tree().process_frame
	player = PlayerGlobal.player_instance.CharacterBody;
	var movement_states: Array[State] = [EnemyIdleState.new(self), EnemyRoamState.new(self), EnemyJumpState.new(self),
	 EnemyFollowState.new(self),EnemyJumpDownState.new(self),EnemyAttack1State.new(self),EnemyAttack2State.new(self)]
	var action_states: Array[State] = [EnemyNoneState.new(self),EnemyAttack1State.new(self),EnemyAttack2State.new(self)]
	movement_state_machine.start_machine(movement_states)
	action_state_machine.start_machine(action_states)
	follow_end_timer = 100


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
	
	if is_dashing:
		velocity.x = dash_vector * dash_speed
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			velocity.x = 0# Stop the dash
			
			
	follow_end_timer+=delta
	##Jump Up And flip
	if (low_ray1.is_colliding()):
		low_collision = true
	else :
		low_collision = false
	##Jump Down
	if(down_ray1.is_colliding()):
		down_collision = true
	else:
		down_collision = false
	flip_children()
	was_on_floor = is_on_floor()
	if(player):
		player_position = player.global_position
		to_player = player.global_position - global_position
	timer += delta
	if(timer > dash_duration and condition == false):
		follow_end_timer = 100
		condition = true
	move_and_slide()

func jump():
	velocity.y = -jump_force

		
func perform_attack() -> void:
	pass
func can_see_player() -> bool:
	if not is_instance_valid(player):
		return false
	
	var distance = to_player.length()
		
	if distance < near_detection_range:
		follow_end_timer = 0.0
		return true
	if player_ray1.is_colliding() || player_ray2.is_colliding():
		follow_end_timer = 0.0
		return true
	#
	#if _facing==Facing.RIGHT && to_player.x<0:
		#return false
	#if _facing==Facing.LEFT && to_player.x>0:
		#return false

##TODO:Have to do a check for player
	if follow_end_timer>seen_player_timer:
		return false
	else:
		return true

func flip_children():
	if(_facing==Facing.RIGHT):
		low_ray1.scale.x = abs(low_ray1.scale.x)
		down_ray1.scale.x = abs(down_ray1.scale.x)
		player_ray1.scale.x = abs(player_ray1.scale.x)
		player_ray2.scale.x = abs(player_ray2.scale.x)
		Attack1Hitbox.scale.x = abs(Attack1Hitbox.scale.x)
		Attack2Hitbox.scale.x = abs(Attack2Hitbox.scale.x)
	else:
		low_ray1.scale.x = -abs(low_ray1.scale.x)
		down_ray1.scale.x = -abs(down_ray1.scale.x)
		player_ray1.scale.x = -abs(player_ray1.scale.x)
		player_ray2.scale.x = -abs(player_ray2.scale.x)
		Attack1Hitbox.scale.x = -abs(Attack1Hitbox.scale.x)	
		Attack2Hitbox.scale.x = -abs(Attack2Hitbox.scale.x)

func flip():
	scale.x = -scale.x

func set_facing_direction(direction: float) -> void:
	if direction > 0:
		_facing = Facing.RIGHT
		sprite.flip_h = false
	elif direction < 0:
		_facing = Facing.LEFT
		sprite.flip_h = true
			
func transition_to_state(state:String)-> void:
	movement_state_machine.transition(state)

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
			sprite.flip_h = true
		else:
			sprite.flip_h = false


func dash():
	is_dashing = true
	dash_timer = dash_duration
	if _facing == Facing.RIGHT:
		dash_vector = 1 
	else:
		dash_vector = -1
