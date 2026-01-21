extends IActionPolicy
class_name PlayerPolicy

func validate(state_id: StringName, intent: Intent, facts: Facts) -> bool:
	match intent.type:
		Intent.Type.ATTACK:
			match intent.attack_kind:
				&"light":
					return true
					# return facts.target_in_range
				&"heavy":
					return facts.target_in_range and facts.is_grounded

		Intent.Type.MOVE:
			return true

	return true
