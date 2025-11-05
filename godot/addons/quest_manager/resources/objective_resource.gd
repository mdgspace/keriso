@tool
extends Resource
class_name ObjectiveResource

@export var type: String  # e.g., "kill", "collect", "talk"
@export var target: String
@export var required: int = 1
var current: int = 0 : set = _set_current, get = _get_current

func _set_current(value): current = clamp(value, 0, required)
func _get_current(): return current

func is_complete() -> bool:
	return current >= required

func update(event: String, value: String) -> void:
	if event == type and value == target:
		current += 1
