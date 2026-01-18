extends IState
class_name WalkState

func get_id() -> StringName:
	return &"walk"

func update(facts: Facts) -> Intent:
	var intent := Intent.new()

	# Stop walking → go back to idle
	if facts.input.horizontal == 0:
		intent.type = Intent.Type.CHANGE_STATE
		intent.target_state = &"idle"
		return intent

	# Keep walking
	intent.type = Intent.Type.MOVE
	intent.move_axis = facts.input.horizontal

	# Optional jump while walking
	if facts.input.just_pressed.get("jump", false):
		intent.type = Intent.Type.JUMP

	return intent
