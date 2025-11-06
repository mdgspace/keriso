extends Saveable

@onready var InteractUI = $"../CharacterBody2D/InteractUI"
@onready var InventoryUI = $"../CharacterBody2D/Inventory"

# Invenntory array
var inventory = []

#signals
signal inventory_updated



@onready var inventory_slot_scene = preload("res://scenes/InventorySlot.tscn")

#var PlayerNode: Node = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if save_id == "":
		save_id = "inventory_manager"
		
	super._ready()
	inventory.resize(20)
	

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["item_type"] == item["item_type"] and inventory[i]["item_name"] == item["item_name"] and inventory[i]["item_effect"] == item["item_effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true 
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
	return false
	
func remove_item(item, quantity):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["item_type"] == item["item_type"] and inventory[i]["item_name"] == item["item_name"] and inventory[i]["item_effect"] == item["item_effect"]:
			print(inventory[i]["quantity"])
			print(quantity)
			inventory[i]["quantity"] -= quantity;
			print("quantity in inventory is", inventory[i]["quantity"])
			print(quantity)
			if inventory[i]["quantity"] <= 0:
				print("Marking empty slot as null")
				inventory[i] = null
			break;
	inventory_updated.emit()

	
func increase_inventory_size():
	inventory_updated.emit()
	pass
	

	
func drop_item(item):
	var item_scene = load(item["scene_path"]);
	#print(item_scene)
	print(item)
	var item_instance = item_scene.instantiate();
	print(item_instance)
	await get_tree().get_frame();
	get_tree().current_scene.add_child(item_instance);
	item_instance.global_position = PlayerGlobal.player_instance.CharacterBody.global_position + Vector2(randf_range(2, 6), 0);
	item_instance.set_item_data(item);
	#print(item_instance)
	
	remove_item(item, item["quantity"])
	
	
func get_save_data() -> Dictionary:
	print("Saving inventory manager")
	var serialized_inventory := []
	for item in inventory:
		if item != null:
			# Duplicate the dictionary to avoid shared reference bugs
			serialized_inventory.append(item.duplicate(true))
		else:
			serialized_inventory.append(null) 
	return {
		"inventory": serialized_inventory
	}


func load_save_data(data: Dictionary) -> void:
	if not data.has("inventory"):
		push_warning("Save data missing 'inventory' key")
		return

	var loaded_inventory = data["inventory"]
	inventory.resize(loaded_inventory.size())
	for i in range(loaded_inventory.size()):
		inventory[i] = loaded_inventory[i] # Might be null or a dictionary
	inventory_updated.emit()
	
func apply_item_effect(item):
	match item["item_type"]:
		"consumable":
			match item["item_effect"]:
				"heal":
					print("increasing stamina")
					return 1;
			return 0; # Returning the number of items to be consumed
		"permanent_item":
			pass
			return 0;  # If it's a permanent item like homeward idol, we can return 0
		"quest_item":
			pass
			# use function to call quest status update using data in item.
			# change item's definition to support this (to have metadata about quest)
			return item["quantity"];  # In quests like deliver items, all the quest item
			# gets consumed. Instead of this, make the quest status update itself return 
			# the variable of items being consumed and return that here.
