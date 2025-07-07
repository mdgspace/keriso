@tool
extends Node2D

# Defining different properties of an inventory item
@export var item_name = ""
@export var item_type = ""
@export var item_texture: Texture
@export var item_effect = ""
var quantity = 1;
var scene_path: String = "res://scenes/Inventory_Item.tscn"
 
@onready var icon_sprite = $Sprite2D


var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
	if(player_in_range and InputNode.is_just_pressed("interact")):
		pickup_item()

func pickup_item():
	var item = {
		"quantity": quantity,
		"item_type": item_type,
		"item_name": item_name,
		"item_effect": item_effect,
	 	"scene_path": scene_path,
		"item_texture": item_texture,
	}
	if InventoryManager.PlayerNode:
		InventoryManager.add_item(item)
		self.queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true;
		body.InteractUI.visible = true;


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false;
		body.InteractUI.visible = false;
		
	
func set_item_data(data):
	#print("Setting item data")
	item_name = data["item_name"];
	item_effect = data["item_effect"];
	item_texture = data["item_texture"];
	item_type = data["item_type"];
	quantity = data["quantity"];
	#print(item_type)
