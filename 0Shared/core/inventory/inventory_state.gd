class_name InventoryState

# item_id → quantity
var items: Dictionary = {}

func add_item(item_id: StringName, quantity := 1) -> void:
	items[item_id] = items.get(item_id, 0) + quantity

func remove_item(item_id: StringName, quantity := 1) -> bool:
	if not items.has(item_id):
		return false
	
	items[item_id] -= quantity
	if items[item_id] <= 0:
		items.erase(item_id)
	
	return true

func has_item(item_id: StringName, quantity := 1) -> bool:
	return items.get(item_id, 0) >= quantity

# ---- Save hooks ----
func get_save_data() -> Dictionary:
	return items.duplicate(true)

func load_save_data(data: Dictionary) -> void:
	items = data.duplicate(true)
