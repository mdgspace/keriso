class_name PlayerState extends State


var player: PlayerController
var animatedsprite2d: AnimatedSprite2D
var main_state_machine: StateMachine


func _init(player_controller: PlayerController) -> void:
	player = player_controller
	animatedsprite2d = player.animatedsprite2d
	main_state_machine = player.main_state_machine
