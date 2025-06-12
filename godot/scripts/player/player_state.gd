class_name PlayerState extends State


var player: PlayerController
var animatedsprite2d: AnimatedSprite2D
var movement_state_machine: StateMachine
var action_state_machine: StateMachine

func _init(player_controller: PlayerController) -> void:
	player = player_controller
	animatedsprite2d = player.animatedsprite2d
	movement_state_machine = player.movement_state_machine
	action_state_machine = player.action_state_machine
	
