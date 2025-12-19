extends Node
@onready var panel_3: Panel = $Panel3
@onready var Master: HSlider = $Panel3/Master
@onready var Background: HSlider = $Panel3/Background
@onready var Sfx: HSlider = $Panel3/Sfx


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/game.tscn")
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_options_pressed() -> void:
	panel_3.visible = true


func _on_back_pressed() -> void:
	panel_3.visible = false




var background = preload("res://Music/time_for_adventure.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_audio(background,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	AudioManager.set_master_vol(Master.value/100)
	AudioManager.set_background_vol(Background.value/100)
	AudioManager.set_SFX_vol(Sfx.value/100)
