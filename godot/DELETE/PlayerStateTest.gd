class_name PlayerStateTest extends State


var player: PlayerControllerTest
var animatedsprite2d: AnimatedSprite2D
var movement_state_machine: StateMachine
var action_state_machine: StateMachine

func _init(player_controller: PlayerControllerTest) -> void:
	player = player_controller
	#animatedsprite2d = player.animatedsprite2d
	movement_state_machine = player.lower_fsm
	action_state_machine = player.upper_fsm
