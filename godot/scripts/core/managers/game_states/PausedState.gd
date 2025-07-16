class_name PausedState extends State

static var state_name = "paused"


func get_state_name() -> String:
	return state_name

func enter() -> void:
	print("entering paused state")
	process_mode=Node.PROCESS_MODE_ALWAYS
	if GameManagerNode:
		GameManagerNode.game_state_changed.emit("paused")
		# Pause the game tree
		SaveManagerGlobal.get_tree().paused = true
		
		
func exit() -> void:
	# Unpause when leaving this state
	SaveManagerGlobal.get_tree().paused = false
	print("exiting the Paused State")

func physics_process(delta: float) -> void:
	# Pause menu updates can still happen here
	#print("Pause pressed while in paused state")
	if InputNode.is_just_pressed("pause"):  # ESC key
		if GameManagerNode:
			GameManagerNode.resume_game()
	pass
