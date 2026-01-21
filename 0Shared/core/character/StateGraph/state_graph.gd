class_name StateGraph

var states: Dictionary          # id → IState
var transitions: Dictionary     # from → [to]

func can_transition(
	from: StringName,
	to: StringName,
	facts: Facts
) -> bool:
	
# 1. Structural rule (deny by default)
	if not transitions.has(from):
		if Globals.verbose:
			print(from," state not registered as initial point")
		return false
	if not transitions[from].has(to):
		if Globals.verbose:
			print(from," state has not transition to ", to)
		return false

	# 2. ActionState entry requirements
	var next_state : IState = states[to]
	if next_state is IActionState:
		var reqs : Dictionary = next_state.get_entry_requirements(facts)

		if reqs.has("stamina") and facts.stamina < reqs["stamina"]:
			if Globals.verbose:
				print("doen't have enough stamina to transition")
			return false

		if reqs.has("cooldown") and reqs["cooldown"] > 0:
			if Globals.verbose:
				print("cooldown is positive")
			return false
	
	return true
