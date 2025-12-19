extends Control

@onready var gridContainer = $GridContainer
var InventoryManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	#InventoryManager = PlayerGlobal.player_instance.get_node("InventoryManager")
	#print(PlayerGlobal.player_instance)
	#print("This is inventory manager",InventoryManager)
	#InventoryManager.inventory_updated.connect(_on_inventory_updated)
	#_on_inventory_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_inventory_updated():
	clean_grid_container();
	
	for item in InventoryManager.inventory:
		var slot = InventoryManager.inventory_slot_scene.instantiate();
		gridContainer.add_child(slot);
		if item != null:
			slot.set_item(item);
		else:
			slot.set_empty();
	
func clean_grid_container():
	while gridContainer.get_child_count() > 0:
		var child = gridContainer.get_child(0)
		gridContainer.remove_child(child)
		child.queue_free()
