extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.visible = false

@onready var parent = $"."
@onready var label_ref = $Area2D/Control/ColorRect/Label
@export var labelText = ""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label_ref.text = labelText




func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entered ", body)
	if body.is_in_group("Player"):
		print(body)
		parent.visible = true




func _on_area_2d_body_exited(body: Node2D) -> void:
	print("entered ", body)
	if body.is_in_group("Player"):
		print(body)
		parent.visible = false
