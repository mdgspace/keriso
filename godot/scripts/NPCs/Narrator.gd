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
	NarratorPhase.INTRO: {"title":"intro","been_played_before":false},
	NarratorPhase.TUTORIAL_FIGHT: {"title":"tutorial_fight","been_played_before":false}
}
func play_given_phase(phase):
	if is_narrating:
		return
	if phase_to_title[phase]["been_played_before"]:
		return
	is_narrating = true
	is_fullscreen = true
	var title = phase_to_title.get(phase, "").get("title","")
	if title != "":
		phase_to_title[phase]["been_played_before"] = true
		dialogue_manager.show_dialogue_balloon(dialogue_resource, title)



func _ready():
	if dialogue_manager:
		dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	is_narrating = false
	is_fullscreen = false
