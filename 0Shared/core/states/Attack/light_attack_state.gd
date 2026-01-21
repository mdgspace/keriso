# core/states/combat/light_attack_state.gd
extends BaseAttackState
class_name LightAttackState

func get_id() -> StringName:
	return &"light_attack"

func get_entry_requirements(_facts: Facts) -> Dictionary:
	return { "stamina": 15 }

func get_hit_frame() -> int:
	return 6

func get_recovery_frames() -> int:
	return 50

func get_attack_kind() -> StringName:
	return &"light"
