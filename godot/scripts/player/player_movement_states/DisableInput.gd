class_name PlayerDisableInputState extends PlayerState

static var state_name = "PlayerDisableState"

func enter() -> void:
	pass

func process(_delta: float) -> void:
	player.velocity = Vector2(0,0)
	print(NarratorGlobal.is_narrating)
	if !NarratorGlobal.is_narrating:
		state_machine.transition("PlayerIdleState")

		
func get_state_name() -> String:
	return state_name
