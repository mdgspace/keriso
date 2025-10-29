class_name InGameState extends State

static var state_name = "in_game"

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(delta: float) -> void:
	# Handle pause input
	#print("Inside InGameState")  
	pass

func physics_process(delta: float) -> void:
	# Any in-game specific physics processing
	if InputNode.is_just_pressed("pause"):
		if GameManagerNode:
			GameManagerNode.pause_game()
	pass

func get_state_name() -> String:
	return state_name
