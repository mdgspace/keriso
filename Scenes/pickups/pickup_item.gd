extends Node2D
class_name PickupItem

@export var item_id: StringName
@export var quantity := 1

signal pickup_requested(item_id, quantity)

func _on_body_entered(body: Node) -> void:
	if body is Character:
		pickup_requested.emit(item_id, quantity)
