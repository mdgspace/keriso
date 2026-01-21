class_name IActionState
extends IState

## Declares upfront cost / commitment to enter this state
func get_entry_requirements(_facts: Facts) -> Dictionary:
	# Example:
	# { "stamina": 20 }
	return {}
