extends Character
class_name PlayerCharacter

func _ready() -> void:
	super._ready()

	brain = Brain.new()
	brain.policy = PlayerPolicy.new()
	
	# Brain signal connected after creation
	brain.intent_approved.connect(_execute_intent)

	# Register states
	var idle := IdleState.new()
	var walk := WalkState.new()

	brain.states[idle.get_id()] = idle
	brain.states[walk.get_id()] = walk

	# Initial state
	brain.change_state(idle.get_id(), facts)

func on_pickup(item_id: StringName, quantity: int) -> void:
	inventory.add_item(item_id, quantity)
