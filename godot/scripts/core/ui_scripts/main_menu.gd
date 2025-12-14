extends Control

# ---------- MENU / PANELS ----------
@onready var settings_panel: Panel = $Panel/settings

# ---------- BUTTONS ----------
@onready var play_button: Button = $Panel/ControlButtons/PLAY/Button
@onready var resume_button: Button = $Panel/ControlButtons/RESUME/Button
@onready var settings_button: Button = $Panel/ControlButtons/SETTINGS/Button
@onready var quit_button: Button = $Panel/ControlButtons/Quit/Button

# ---------- SLIDERS ----------
@onready var volume_slider: HSlider = $Panel/settings/VolumeSlider
@onready var sfx_slider: HSlider = $Panel/settings/SFXSlider
@onready var brightness_slider: HSlider = $Panel/settings/BrightnessSlider


func _ready() -> void:
	# Hide settings at start
	settings_panel.visible = false

	# --- Initialize audio sliders ---
	volume_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Master")
		)
	)

	sfx_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("SFX")
		)
	)

	# Brightness default
	brightness_slider.value = 1.0


	# --- Button connections ---
	play_button.pressed.connect(_on_play_pressed)
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# --- Slider connections ---
	volume_slider.value_changed.connect(_on_volume_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	brightness_slider.value_changed.connect(_on_brightness_slider_value_changed)


func _on_play_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/world/game.tscn")

func _on_resume_pressed() -> void:
	#link loading
	return

func _on_settings_pressed() -> void:
	settings_panel.visible = !settings_panel.visible

func _on_quit_pressed() -> void:
	get_tree().quit()

# ---------- SLIDER LOGIC ----------

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value)
	)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(value)
	)

func _on_brightness_slider_value_changed(value: float) -> void:
	# value: 0 = dark, 1 = normal
	return
