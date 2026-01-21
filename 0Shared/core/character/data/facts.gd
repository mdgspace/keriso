class_name Facts

var input: InputSnapshot = InputSnapshot.new()

# Character physical state
var velocity: Vector2
var is_on_floor: bool

# Combat / control state
var is_locked: bool = false
var stamina: float = 100000000.0

# Time
var frame: int = 0

# Inventory
var inventory_items: Dictionary = {}

func inventory_has_item(item_id: StringName, quantity := 1) -> bool:
	return inventory_items.get(item_id, 0) >= quantity
