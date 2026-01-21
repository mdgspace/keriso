class_name Intent

enum Type {
	NONE,
	MOVE,
	JUMP,
	ATTACK,
}

var type: Type = Type.NONE

# Optional payload
var move_axis: float = 0.0
var item_id: StringName

# Attack (Offensive acts) i.e. "lightAttack", "heavyAttack", "bow" etc.
var attack_kind: StringName = &""
