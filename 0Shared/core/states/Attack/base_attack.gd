# core/states/combat/base_attack_state.gd
extends IActionState
class_name BaseAttackState

var enter_frame: int = -1

func get_startup_frames() -> int:
	return 0

func get_hit_frame() -> int:
	return 0

func get_recovery_frames() -> int:
	return 0

func get_attack_kind() -> StringName:
	return &""

func get_entry_requirements(_facts: Facts) -> Dictionary:
	return {}

func enter(facts: Facts) -> void:
	enter_frame = facts.frame
	print("attack enter at frame ", enter_frame)

func update(facts: Facts) -> StateResult:
	var r := StateResult.new()
	
	var elapsed := facts.frame - enter_frame

	# hit moment
	if elapsed == get_hit_frame():
		var i := Intent.new()
		i.type = Intent.Type.ATTACK
		i.attack_kind = get_attack_kind()
		r.animation = get_id()
		r.intent = i

	# recovery done → exit
	if elapsed >= get_recovery_frames():
		if Globals.verbose:
			print("Recovery done at: ", facts.frame)
		r.next_state = &"idle"

	return r

func exit() -> void:
	if Globals.verbose:
		print("exiting ", get_id(), " state")
	pass
