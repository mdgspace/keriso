class_name PlayerParryState extends PlayerState

static var state_name := "PlayerParryState"

func get_state_name() -> String:
	return state_name

func enter():
	player.animation_state = state_name
