extends IActionPolicy
class_name PlayerPolicy

func validate(
	current_state: StringName,
	intent: Intent,
	facts: Facts
) -> bool:
	# Global lock: hitstun, cutscene, etc.
	if facts.is_locked:
		return false

	match intent.type:
		Intent.Type.USE_ITEM:
			# Only CHECK, never EXECUTE
			return facts.has_item(intent.item_id)

		Intent.Type.JUMP:
			return facts.is_on_floor

		Intent.Type.MOVE:
			return true

		Intent.Type.ATTACK:
			# Later: stamina, weapon equipped, cancel windows
			return true

		Intent.Type.OPEN_INVENTORY:
			return facts.is_on_floor

		Intent.Type.CHANGE_STATE:
			return true

	return true
