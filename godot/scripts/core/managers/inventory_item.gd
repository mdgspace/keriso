@tool
extends Node2D

# Defining different properties of an inventory item
@export var item_name = ""
@export var item_type = ""
@export var item_texture: Texture
var texture_path = ""
@export var item_effect = ""
var quantity = 1;
var scene_path: String = "res://scenes/Inventory_Item.tscn"
 
@onready var icon_sprite = $Sprite2D
var InventoryManager


var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("icon_sprite:", icon_sprite)
	await get_tree().process_frame
	#print(PlayerGlobal)
	#print(PlayerGlobal.player_instance)
	InventoryManager = PlayerGlobal.player_instance.get_node("InventoryManager")
	
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	
	if texture_path == "" and item_texture:
		texture_path = item_texture.resource_path


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
		"texture_path": texture_path,
	}

	InventoryManager.add_item(item)
	self.queue_free()



func _on_area_2d_body_entered(body: Node) -> void:
	print("entered ", body)
	if body.is_in_group("Player"):
		print(body)
		player_in_range = true;
		body.main_player.InteractUI.visible = true;


func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false;
		body.main_player.InteractUI.visible = false;
		
	
func set_item_data(data):
	#print("Setting item data")
	item_name = data["item_name"];
	item_effect = data["item_effect"];
	texture_path = data["texture_path"];
	item_type = data["item_type"];
	quantity = data["quantity"];
	
	quantity = int(quantity);
	
	if texture_path != "":
		print(texture_path)
		item_texture = load(texture_path)
		print(item_texture)
		print(icon_sprite)
		icon_sprite.texture = item_texture
	#print(item_type)
