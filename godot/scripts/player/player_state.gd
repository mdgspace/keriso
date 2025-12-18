class_name PlayerState extends State


var player: PlayerController
var sprite2d: Sprite2D
var state_machine: StateMachine
var animationplayer:AnimationPlayer
#var action_state_machine: StateMachine

func _init(player_controller: PlayerController) -> void:
	player = player_controller
	sprite2d = player.animatedsprite2d
	state_machine = player.state_machine
	animationplayer = player.animation_player
	#action_state_machine = player.action_state_machine
	
