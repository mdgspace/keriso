class_name Intent

enum Type {
	NONE,
	MOVE,
	JUMP,
	ATTACK,
	INTERACT,
	OPEN_INVENTORY,
	USE_ITEM,
	CHANGE_STATE
}

var type: Type = Type.NONE

# Optional payload
var move_axis: float = 0.0
var item_id: StringName
var target_state: StringName
