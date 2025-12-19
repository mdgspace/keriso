extends Node2D
# NOTE: Whenever you create an NPC, put NarratorGlobal.is_narrating = true to disable input and back to false to enable them
@onready var dialogue_manager = DialogueManager #this is an autoload
@export var dialogue_resource: DialogueResource

var in_dialogue := false

func _ready():
	if dialogue_manager:
		dialogue_manager.dialogue_started.connect(_on_dialogue_started)
		dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)

func interact():
	if in_dialogue:
		return

	dialogue_manager.show_dialogue_balloon(dialogue_resource, "start")

func _on_dialogue_started(resource: DialogueResource) -> void:
	in_dialogue = true
	NarratorGlobal.is_narrating = true
	
func _on_dialogue_ended(resource: DialogueResource) -> void:
	in_dialogue = false
	NarratorGlobal.is_narrating = false
