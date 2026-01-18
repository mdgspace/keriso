class_name InventoryItemData

var item_id: StringName
var item_type: StringName
var effects: Dictionary = {}
var stackable: bool = true
var max_stack: int = 99

func _init(
	_id: StringName,
	_type: StringName,
	_effects := {},
	_stackable := true,
	_max_stack := 99
) -> void:
	item_id = _id
	item_type = _type
	effects = _effects
	stackable = _stackable
	max_stack = _max_stack
