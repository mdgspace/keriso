class_name EnemyState
extends State

var enemy: Enemy
var animatedsprite2d: AnimatedSprite2D
var movement_state_machine: StateMachine
var action_state_machine: StateMachine

func _init(enemy_controller: Enemy) -> void:
	enemy = enemy_controller
	animatedsprite2d = enemy.animatedsprite2d
	movement_state_machine = enemy.movement_state_machine
	action_state_machine = enemy.action_state_machine
