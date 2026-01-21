extends Character
class_name PlayerCharacter

func _ready() -> void:
	
	super._ready()
	
	_initialize_input()
	_initialize_brain()
	_register_states()
	_register_transitions()
	_set_initial_state()
	
	brain.tick(facts)   # force first animation evaluation


func on_pickup(item_id: StringName, quantity: int) -> void:
	inventory.add_item(item_id, quantity)

# Setup InputService
func _initialize_input() -> void:
	InputService.input_snapshot_ready.connect(_on_input_snapshot)

# Handle brain initialization
func _initialize_brain() -> void:
	brain = Brain.new()
	brain.state_graph = StateGraph.new()
	brain.policy = PlayerPolicy.new()
	
	# Brain signal connected after creation
	brain.intent_approved.connect(_execute_intent)
	# Connect animation controller signal to request animation
	brain.animation_requested.connect($AnimationController.request)
	
	
#register states
## TODO: STATE FACTORY FOR REGISTERING STATES
func _register_states() -> void:
	var idle := IdleState.new()
	var walk := WalkState.new()
	var light_attack := LightAttackState.new()
	var heavy_attack := HeavyAttackState.new()

	var sg := brain.state_graph
	sg.states[idle.get_id()] = idle
	sg.states[walk.get_id()] = walk
	sg.states[light_attack.get_id()] = light_attack
	sg.states[heavy_attack.get_id()] = heavy_attack

#register transitions
func _register_transitions() -> void:
	brain.state_graph.transitions = {
		&"idle": {
			&"walk": true,
			&"light_attack": true,
			&"heavy_attack": true
		},
		&"walk": {
			&"idle": true,
			&"light_attack": true,
			&"heavy_attack": true
		},
		&"light_attack": {
			&"idle": true
		},
		&"heavy_attack": {
			&"idle": true
		}
	}

func _set_initial_state() -> void:
	brain._change_state(&"idle", facts)
