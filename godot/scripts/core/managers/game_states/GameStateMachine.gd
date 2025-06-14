class_name GameStateMachine extends StateMachine

# Game-specific state machine that extends your base StateMachine
signal game_state_changed(old_state: String, new_state: String)

func _init(manager: GameManager) -> void:
	is_log_enabled = true

func initialize_game_states() -> void:
	var initial_states: Array[State] = [
		InGameState.new(),
		PausedState.new(),
		CutsceneState.new()
	]
	
	start_machine(initial_states)

func transition_to_game_state(new_state_name: String) -> void:
	var old_state_name = current_state.get_state_name() if current_state else ""
	transition(new_state_name)
	game_state_changed.emit(old_state_name, new_state_name)

func get_current_game_state() -> String:
	return current_state.get_state_name() if current_state else ""

func is_in_state(state_name: String) -> bool:
	return get_current_game_state() == state_name
