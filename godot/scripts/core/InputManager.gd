extends Node

class_name InputManager

## Stores input buffer for single-frame input detection
var _input_just_pressed: Dictionary = {}
var _input_just_released: Dictionary = {}
var _last_input_time: Dictionary = {}
## Define your game actions here and add in InputMap
const ACTIONS := [
	"move_left", "move_right",
	"jump", "attack", "interact", "pause"
]

func _ready() -> void:
	# Ensure all actions exist in InputMap
	for action in ACTIONS:
		if not InputMap.has_action(action):
			push_warning("Missing input action: %s" % action)

func _physics_process(delta: float) -> void:
	_update_input_buffer()

func _update_input_buffer() -> void:
	_input_just_pressed.clear()
	_input_just_released.clear()
	for action in ACTIONS:
		_input_just_pressed[action] = Input.is_action_just_pressed(action)
		_input_just_released[action] = Input.is_action_just_released(action)

##All the functions we will be using
func is_pressed(action_name: String) -> bool:
	if not InputMap.has_action(action_name):
		push_warning("Checked undefined input: %s" % action_name)
		return false
	return Input.is_action_pressed(action_name)

func is_just_pressed(action_name: String) -> bool:
	return _input_just_pressed.get(action_name, false)

func is_just_released(action_name: String) -> bool:
	return _input_just_released.get(action_name, false)
	
func is_buffered_input(action_name: String, buffer_time_sec: float) -> bool:
	if not InputMap.has_action(action_name):
		push_warning("Checked undefined input: %s" % action_name)
		return false

	var current_time: float = Time.get_ticks_msec() / 1000.0

	# Check if action is just pressed this frame
	if _input_just_pressed.get(action_name, false):
		var last_time: float = _last_input_time.get(action_name, -INF)
		if current_time - last_time >= buffer_time_sec:
			_last_input_time[action_name] = current_time
			return true

	return false
# For analog inputs and easy handling
func horizontal_input()-> float:
	var horizontalinput = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return horizontalinput
	
func remap_action(action_name: String, new_event: InputEvent) -> void:
	if not InputMap.has_action(action_name):
		push_warning("Trying to remap undefined input: %s" % action_name)
		return
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, new_event)
