class_name CutsceneState extends State

var can_skip: bool = true		# True if cutscene can be skipped

# TODO: Define input actions for skipping during a cutscene in InputManager
var skip_input_actions: Array[String] = ["ui_accept", "ui_select"]
static var state_name = "cutscene"

func get_state_name() -> String:
	return state_name

func enter() -> void:
	if GameManagerNode:
		GameManagerNode.game_state_changed.emit("cutscene")
		# Disable player input during cutscenes
		_disable_player_input()

func exit() -> void:
	# Re-enable player input when leaving cutscene
	_enable_player_input()

	
func _physics_process(delta: float) -> void:
	# TODO: define logic for ending cutscene using the defined input.
	pass 

func set_skippable(skippable: bool) -> void:
	can_skip = skippable

func _disable_player_input() -> void:
	# Disable player controller if it exists
	if GameManagerNode and GameManagerNode.player:
		if GameManagerNode.player.has_method("set_input_enabled"):
			GameManagerNode.player.set_input_enabled(false)

func _enable_player_input() -> void:
	# Re-enable player controller
	if GameManagerNode and GameManagerNode.player:
		if GameManagerNode.player.has_method("set_input_enabled"):
			GameManagerNode.player.set_input_enabled(true)
