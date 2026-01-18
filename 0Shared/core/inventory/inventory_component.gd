extends Node
class_name InventoryComponent

@export var save_id: StringName = &"player_inventory"

var state := InventoryState.new()

func _ready() -> void:
	if save_id == &"":
		push_warning("%s has empty save_id" % name)
	else:
		SaveManager.register_saveable(self)
		
func add_item(item_id: StringName, quantity := 1) -> void:
	state.add_item(item_id, quantity)

func consume_item(item_id: StringName, quantity := 1) -> bool:
	return state.remove_item(item_id, quantity)

func has_item(item_id: StringName, quantity := 1) -> bool:
	return state.has_item(item_id, quantity)

# ---- Saveable ----
func get_save_data() -> Dictionary:
	return state.get_save_data()

func load_save_data(data: Dictionary) -> void:
	state.load_save_data(data)
