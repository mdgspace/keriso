extends Node

@onready var InteractUI = $CharacterBody2D/InteractUI
@onready var InventoryUI = $CharacterBody2D/Inventory
@onready var CharacterBody = $CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
