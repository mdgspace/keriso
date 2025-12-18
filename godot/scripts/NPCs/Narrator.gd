extends Node2D

@onready var dialogue_manager = DialogueManager #this is an autoload
@export var dialogue_resource: DialogueResource
var is_narrating = false
var is_fullscreen = false

enum NarratorPhase {
	INTRO,
	TUTORIAL_FIGHT
}

var current_phase: NarratorPhase = NarratorPhase.INTRO

var phase_to_title := {
	NarratorPhase.INTRO: "intro",
	NarratorPhase.TUTORIAL_FIGHT: "tutorial_fight"
}
func play_current_phase():
	if is_narrating:
		return
	is_narrating = true
	is_fullscreen = true
	var title = phase_to_title.get(current_phase, "")
	if title != "":
		dialogue_manager.show_dialogue_balloon(dialogue_resource, title)

func advance_phase():
	current_phase += 1
	play_current_phase()

func _ready():
	if dialogue_manager:
		dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	is_narrating = false
	is_fullscreen = false
