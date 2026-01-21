class_name IState

func enter(_facts: Facts) -> void:
	pass

func update(_facts: Facts) -> StateResult:
	return StateResult.new()

func exit() -> void:
	pass

func get_id() -> StringName:
	return &""
