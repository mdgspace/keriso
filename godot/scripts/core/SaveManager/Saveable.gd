extends Node
class_name Saveable


@export var save_id := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if save_id == "":
		push_warning("save id missing")
		return
	SaveManagerGlobal._on_register_saveable(self)


# Functions that are to be overidden for every individual saveable
func get_save_data() -> Dictionary:
	return {}
	
func load_save_data(data: Dictionary) -> void:
	pass
