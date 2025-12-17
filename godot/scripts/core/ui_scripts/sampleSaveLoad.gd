extends Control
@onready var save: Button = $save
@onready var master: HSlider = $Master
@onready var background: HSlider = $Background
@onready var sfx: HSlider = $SFX


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	var volArr = AudioManager.ReturnLastVolArray()
	master.value = volArr[0]*100
	background.value = volArr[1]*100
	sfx.value = volArr[2]*100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_load_pressed() -> void:
	SaveManagerGlobal.load_game();


func _on_save_pressed() -> void:
	SaveManagerGlobal.save_game();


func _on_quit_pressed() -> void:
	get_tree().quit()
