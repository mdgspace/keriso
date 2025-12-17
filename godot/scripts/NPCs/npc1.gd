extends Node2D

@onready var dialogue_manager = get_tree().get_first_node_in_group("DialogueManager")
@export var dialogue_resource: DialogueResource

var in_dialogue := false

func _ready():
	if dialogue_manager:
		dialogue_manager.dialogue_started.connect(_on_dialogue_started)
		dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)

func interact():
	if in_dialogue:
		return

	DialogueManager.show_dialogue_balloon(dialogue_resource, "start")

func _on_dialogue_started(resource: DialogueResource) -> void:
	in_dialogue = true

func _on_dialogue_ended(resource: DialogueResource) -> void:
	in_dialogue = false
