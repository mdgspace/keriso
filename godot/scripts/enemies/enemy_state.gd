class_name EnemyState extends State

var enemy: Enemy
var animationstate 
var AnimationState
var movement_state_machine: StateMachine
var action_state_machine: StateMachine

func _init(enemy_controller: Enemy) -> void:
	enemy = enemy_controller
	animationstate = enemy.animation_state
	AnimationState = enemy.Animation_State
	movement_state_machine = enemy.movement_state_machine
	action_state_machine = enemy.action_state_machine
