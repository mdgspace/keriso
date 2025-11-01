class_name LowerBodyState extends PlayerStateTest

var state_machine: StateMachine

func _init(player_controller: PlayerControllerTest):
	super(player_controller)  # Call the parent constructor properly
	state_machine = player.lower_fsm
