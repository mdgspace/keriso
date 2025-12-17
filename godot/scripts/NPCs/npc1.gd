extends Node2D

@onready var dialogue_manager = get_tree().get_first_node_in_group("DialogueManager")
@export var dialogue_resource: DialogueResource
@onready var dialogue_label: DialogueLabel = $DialogueLabel

var has_dialogue_started= false;
func interact():
	if not DialogueManager.dialogue_active:
		DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
		
	
