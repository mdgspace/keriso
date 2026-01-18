extends Node

signal input_snapshot_ready(snapshot)

const ACTIONS := [
	"move_left", "move_right",
	"jump", "attack", "interact",
	"dash", "inventory"
]

func _physics_process(_delta: float) -> void:
	var snapshot := InputSnapshot.new()

	for a in ACTIONS:
		snapshot.just_pressed[a] = Input.is_action_just_pressed(a)
		snapshot.just_released[a] = Input.is_action_just_released(a)
		snapshot.is_pressed[a] = Input.is_action_pressed(a)

	snapshot.horizontal = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)

	input_snapshot_ready.emit(snapshot)
