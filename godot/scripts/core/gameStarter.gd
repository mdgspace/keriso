extends Node2D
@onready var Master: HSlider = $Camera2D/Master
@onready var Background: HSlider = $Camera2D/Background
@onready var Sfx: HSlider = $Camera2D/SFX

var background = preload("res://Music/We Rollin - Djjohal.fm.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_audio(background,1)
	if PlayerGlobal.player_instance == null:
		print("Starting instantiation of player")
		var player = PlayerGlobal.player_scene.instantiate()
		add_child(player)
		PlayerGlobal.player_instance = player
		print("Instantiated player")
		var dengey = PlayerGlobal.player_instance
		print(dengey);

func _process(delta: float) -> void:
	AudioManager.set_master_vol(Master.value/100)
	AudioManager.set_background_vol(Background.value/100)
	AudioManager.set_SFX_vol(Sfx.value/100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
