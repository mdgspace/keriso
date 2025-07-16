extends Node

@onready var inventoryCanvas = $"../CharacterBody2D/Inventory"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (InputNode.is_just_pressed("inventory")):
		print("alternating inventory")
		inventoryCanvas.visible = !inventoryCanvas.visible
		#print(inventoryCanvas.visible)
		get_tree().paused = !get_tree().paused
		
