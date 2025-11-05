extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var currentState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if GameManagerNode:
		currentState = GameManagerNode.game_state_machine.get_current_game_state()
	else:
		print("game manager node not found")
	
	if currentState == "paused":
		visible = true
	else:
		visible = false
	
	
	pass
