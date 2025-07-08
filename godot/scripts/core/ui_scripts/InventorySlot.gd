extends Control

@onready var icon = $innerBorder/itemIcon
@onready var quantity_label = $innerBorder/itemQuantity
@onready var details_panel = $DetailsPanel
@onready var usage_panel = $UsagePanel
@onready var item_name = $DetailsPanel/name
@onready var item_type = $DetailsPanel/type
@onready var item_effect = $DetailsPanel/effect

var item = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(usage_panel)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_button_pressed() -> void:
	if item != null:
		usage_panel.visible = !usage_panel.visible;
		details_panel.visible = false;


func _on_item_button_mouse_entered() -> void:
	if item != null:
		usage_panel.visible = false;
		details_panel.visible = true;


func _on_item_button_mouse_exited() -> void:
	if item != null:
		details_panel.visible = false;
		
func set_empty():
	icon.texture = null;
	quantity_label.text = "";




func set_item(new_item):
	#print("setting item")
	item = new_item;
	#print(item)
	if new_item.has("texture_path") and new_item["texture_path"] != "":
		icon.texture = load(new_item["texture_path"])
	else:
		icon.texture = null
		
	var quantity_int = int(new_item["quantity"]);
	quantity_label.text = str(quantity_int);
	item_name.text = str(new_item["item_name"]);
	item_type.text = str(new_item["item_type"]);
	if(item["item_effect"] != ""):
		item_effect.text = str("+ ", new_item["item_effect"])
	else:
		item_effect.text = ""
		
		



func _on_use_pressed() -> void:
	usage_panel.visible = false;
	if item != null and item["item_effect"] != "" and InventoryManager.PlayerNode:
		print("applying item effect")
		var quantity = InventoryManager.PlayerNode.apply_item_effect(item)
		print("quantity is ", quantity)
		InventoryManager.remove_item(item, quantity);


func _on_drop_pressed() -> void:
	usage_panel.visible = false
	if item != null:
		InventoryManager.drop_item(item);
		#InventoryManager.remove_item(item);
