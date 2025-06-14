extends Saveable
class_name GameManager

signal game_state_changed(new_state: String)
signal player_died
signal player_respawned
signal checkpoint_reached(checkpoint_id: String)
signal boss_defeated(boss_id: String)
signal game_paused
signal game_resumed

@export var player: Node
@export var is_debug_enabled: bool = true

var game_state_machine: GameStateMachine
var is_game_paused: bool = false

var game_data: Dictionary = {
	"current_game_state": "",
	"is_game_paused": false
}

func _ready() -> void:
	if save_id == "":
		save_id = "game_manager"
		
	process_mode=Node.PROCESS_MODE_ALWAYS
	super._ready()  # Register with SaveManager

	_setup_systems()
	_connect_signals()


func _setup_systems() -> void:
	game_state_machine = GameStateMachine.new(self)
	add_child(game_state_machine)

	game_state_machine.initialize_game_states()

func _connect_signals() -> void:
	# -----------------------------------------------------------
	# If there are any signals present in the different systems, connect them here 
	#------------------------------------------------------------
	
	game_state_machine.game_state_changed.connect(_on_game_state_changed)

	_connect_player_signals()

func _connect_player_signals() -> void:
	if not player:
		return
		
	#---------------------------------------------------------------
	# Connect any player related signals over here
	#---------------------------------------------------------------
	
	
	# example:
	#if player.has_signal("died"):
		#player.died.connect(_on_player_death_signal)
		


# implementations of get save data and load save data for a saveable class.
func get_save_data() -> Dictionary:
	
	game_data["current_game_state"] = game_state_machine.get_current_game_state()
	game_data["is_game_paused"] = is_game_paused

	if is_debug_enabled:
		print("GameManager: Saving game data: ", game_data)

	return game_data

func load_save_data(data: Dictionary) -> void:
	if is_debug_enabled:
		print("GameManager: Loading game data: ", data)

	game_data = data

	if data.has("current_game_state"):
		game_state_machine.transition_to_game_state(data["current_game_state"])

	is_game_paused = data.get("is_game_paused", false)


# Signal handlers
func _on_game_state_changed(old_state: String, new_state: String) -> void:
	game_state_changed.emit(new_state)

# Methods to access SaveManager's load and save functions using gamemanager.
func save_game() -> void:
	if SaveManagerGlobal:
		SaveManagerGlobal.save_game()
		if is_debug_enabled:
			print("GameManager: Game saved")

func load_game() -> void:
	if SaveManagerGlobal:
		SaveManagerGlobal.load_game()
		if is_debug_enabled:
			print("GameManager: Game loaded")


func pause_game() -> void:
	if is_game_paused: return
	is_game_paused = true
	game_state_machine.transition_to_game_state("paused")
	game_paused.emit()

func resume_game() -> void:
	if not is_game_paused: return
	is_game_paused = false
	game_state_machine.transition_to_game_state("in_game")
	game_resumed.emit()
