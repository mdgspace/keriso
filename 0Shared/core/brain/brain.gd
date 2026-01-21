class_name Brain

signal intent_approved(intent: Intent)
signal animation_requested(anim: StringName)

var current_state: IState
var state_graph: StateGraph
var policy: IActionPolicy

func tick(facts: Facts) -> void:
	# 0. Forced transitions (Die, Stun, etc.)
	var forced := _check_forced_transition(facts)
	if forced != &"":
		_change_state(forced, facts)
		return

	# 1. State update
	var result := current_state.update(facts)

	# 2. Requested transition
	if result.next_state != &"":
		if state_graph.can_transition(
			current_state.get_id(),
			result.next_state,
			facts
		):
			if Globals.verbose:
				print("Transition from: ", current_state.get_id()," to: ", result.next_state," accepted by State Graph")
			_change_state(result.next_state, facts)
		return  # short-circuit

	# 3. Animation (state is stable)
	if result.animation != &"":
		animation_requested.emit(result.animation, facts)

	# 4. Intent execution
	if result.intent != null:
		if policy.validate(
			current_state.get_id(),
			result.intent,
			facts
		):
			intent_approved.emit(result.intent)


func _change_state(id: StringName, facts: Facts) -> void:
	if current_state:
		current_state.exit()
	current_state = state_graph.states[id]
	current_state.enter(facts)

func _check_forced_transition(facts: Facts) -> String:
	return &""
