class_name Brain

signal intent_approved(intent: Intent)

var current_state: IState
var states: Dictionary = {}
var policy: IActionPolicy

func tick(facts: Facts) -> void:
	if current_state == null:
		return
	
	var intent := current_state.update(facts)
	
	if intent.type == Intent.Type.NONE:
		return
	
	if policy.validate(current_state.get_id(), intent, facts):
		intent_approved.emit(intent)

func change_state(new_state_id: StringName, facts: Facts) -> void:
	if not states.has(new_state_id):
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[new_state_id]
	current_state.enter(facts)
