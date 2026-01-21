extends IState
class_name WalkState

func get_id() -> StringName:
	return &"walk"

func enter(_facts: Facts) -> void:
	pass
	
func exit() -> void:
	pass
	
func update(facts: Facts) -> StateResult:
	var r = StateResult.new()

	# Stop walking → go back to idle
	if facts.input.horizontal == 0:
		r.next_state = &"idle"
		return r

	# Animation
	r.animation = &"walk"
	
	# walking
	var intent = Intent.new()
	intent.type = Intent.Type.MOVE
	intent.move_axis = facts.input.horizontal
	r.intent = intent
	
	# Optional jump while walking
	if facts.input.just_pressed.get("jump", false):
		intent.type = Intent.Type.JUMP

	return r
