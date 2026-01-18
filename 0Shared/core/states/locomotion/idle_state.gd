extends IState
class_name IdleState

func get_id() -> StringName:
	return &"idle"

func update(facts: Facts) -> Intent:
	var intent := Intent.new()
	
	if facts.input.horizontal != 0:
		intent.type = Intent.Type.MOVE
		intent.move_axis = facts.input.horizontal
	
	elif facts.input.just_pressed.get("jump", false):
		intent.type = Intent.Type.JUMP
	
	return intent
