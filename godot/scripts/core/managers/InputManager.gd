extends Node
class_name InputManager

var _input_just_pressed: Dictionary = {}
var _input_just_released: Dictionary = {}

var _last_input_time: Dictionary[String, float] = {}

var _was_pressed: Dictionary[String, bool] = {}

## Define your game actions here and add in InputMap
const ACTIONS := [
	"move_left", "move_right",
	"jump", "attack", "interact", "pause", "inventory"
]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for action in ACTIONS:
		if not InputMap.has_action(action):
			push_warning("Missing input action: %s" % action)

func _physics_process(_delta: float) -> void:
	_update_input_buffer()

func _update_input_buffer() -> void:
	_input_just_pressed.clear()
	_input_just_released.clear()
	for action in ACTIONS:
		_input_just_pressed[action] = Input.is_action_just_pressed(action)
		_input_just_released[action] = Input.is_action_just_released(action)

func is_pressed(action_name: String) -> bool:
	if not InputMap.has_action(action_name):
		push_warning("Checked undefined input: %s" % action_name)
		return false
	return Input.is_action_pressed(action_name)

func is_just_pressed(action_name: String) -> bool:
	return _input_just_pressed.get(action_name, false)

func is_just_released(action_name: String) -> bool:
	return _input_just_released.get(action_name, false)

# True only on the first frame after a full release
func is_first_frame_pressed(action_name: String) -> bool:
	if not InputMap.has_action(action_name):
		push_warning("Checked undefined input: %s" % action_name)
		return false

	var is_pressed_now: bool = Input.is_action_pressed(action_name)
	var was_pressed_before: bool = _was_pressed.get(action_name, false)

	if is_pressed_now and not was_pressed_before:
		_was_pressed[action_name] = true
		return true

	if not is_pressed_now and was_pressed_before:
		_was_pressed[action_name] = false

	return false

# Buffered input check
func is_buffered_input(action_name: String, buffer_time_sec: float) -> bool:
	if not InputMap.has_action(action_name):
		push_warning("Checked undefined input: %s" % action_name)
		return false

	var current_time: float = Time.get_ticks_msec() / 1000.0

	if _input_just_pressed.get(action_name, false):
		var last_time: float = _last_input_time.get(action_name, -INF)
		if current_time - last_time >= buffer_time_sec:
			_last_input_time[action_name] = current_time
			return true

	return false

# For analog inputs
func horizontal_input() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

# Dynamic remapping
func remap_action(action_name: String, new_event: InputEvent) -> void:
	if not InputMap.has_action(action_name):
		push_warning("Trying to remap undefined input: %s" % action_name)
		return
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, new_event)
