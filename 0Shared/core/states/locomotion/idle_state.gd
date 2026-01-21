extends IState
class_name IdleState

func get_id() -> StringName:
	return &"idle"

func enter(_facts: Facts) -> void:
	pass
	
func exit() -> void:
	pass
	
func update(facts: Facts) -> StateResult:
	var r := StateResult.new()
	var intent := Intent.new()
	
	if facts.input.horizontal != 0:
		r.next_state = &"walk"
		return r
	
	if facts.input.just_pressed.get("light_attack", false):
		r.next_state = &"light_attack"
		
	r.animation = &"idle"
	
	if facts.input.just_pressed.get("jump", false):
		intent.type = Intent.Type.JUMP
		return r
	
	return r
