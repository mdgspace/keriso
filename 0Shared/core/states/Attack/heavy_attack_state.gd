# core/states/combat/heavy_attack_state.gd
extends BaseAttackState
class_name HeavyAttackState

func get_id() -> StringName:
	return &"heavy_attack"

func get_entry_requirements(_facts: Facts) -> Dictionary:
	return { "stamina": 35 }

func get_hit_frame() -> int:
	return 12

func get_recovery_frames() -> int:
	return 1000

func get_attack_kind() -> StringName:
	return &"heavy"
