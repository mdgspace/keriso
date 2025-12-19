extends CanvasLayer
@onready var Master: HSlider = $Control/Master
@onready var Background: HSlider = $Control/Background
@onready var Sfx: HSlider = $Control/SFX


var background = preload("res://Music/We Rollin - Djjohal.fm.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioManager.play_audio(background,1)


var currentState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	AudioManager.set_master_vol(Master.value/100)
	AudioManager.set_background_vol(Background.value/100)
	AudioManager.set_SFX_vol(Sfx.value/100)
	
	if GameManagerNode:
		currentState = GameManagerNode.game_state_machine.get_current_game_state()
	else:
		print("game manager node not found")
	
	if currentState == "paused":
		visible = true
	else:
		visible = false
	
	
	pass
