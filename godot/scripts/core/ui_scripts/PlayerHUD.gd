extends Control

@onready var health_bar: TextureProgressBar = $health/TextureProgressBar
@onready var pause_screen: Control = $PauseScreen

var player: Node = null
var paused: bool = false

func _ready() -> void:
	# Pause screen hidden by default
	
	pause_screen.visible = false
	
	
	# Find player safely
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_warning("Player not found. Health bar will not update.")
		return

	# Initialize health bar
	health_bar.min_value = 0
	health_bar.max_value = player.max_health
	health_bar.value = player.health

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
	if(paused and Input.is_action_just_pressed("ui_accept")):
		toggle_pause()
		
	

func toggle_pause() -> void:
	paused = !paused
	get_tree().paused = paused
	pause_screen.visible = paused
