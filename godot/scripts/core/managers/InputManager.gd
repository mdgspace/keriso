extends Node
class_name InputManager

var _input_just_pressed: Dictionary = {}
var _input_just_released: Dictionary = {}

var _last_input_time: Dictionary[String, float] = {}

var _was_pressed: Dictionary[String, bool] = {}
var _last_pressed_frame: Dictionary = {}

## Short/Long press generic variables:-
var _press_start_frame: Dictionary = {}
# A flag to ensure the "held" trigger fires only once per press.
var _held_trigger_fired: Dictionary = {}
# --- Public, single-frame trigger Dictionaries ---
var _short_press_released: Dictionary = {}



## Define your game actions here and add in InputMap
const ACTIONS := [
	"move_left", "move_right",
	"jump", "attack", "interact", "pause", "inventory"
]

func _ready() -> void:
	Input.action_press("attack")
	process_mode = Node.PROCESS_MODE_ALWAYS
	for action in ACTIONS:
		if not InputMap.has_action(action):
			push_warning("Missing input action: %s" % action)


func _physics_process(_delta: float) -> void:
	_update_input_buffer()


func _update_input_buffer() -> void:
	_input_just_pressed.clear()
	_input_just_released.clear()
	_short_press_released.clear()
	var current_frame = Engine.get_physics_frames()
	for action in ACTIONS:
		var just_pressed = Input.is_action_just_pressed(action)
		var just_released = Input.is_action_just_released(action)

		_input_just_pressed[action] = just_pressed
		_input_just_released[action] = just_released
		if just_pressed:
			_last_pressed_frame[action] = current_frame
			_press_start_frame[action] = current_frame
			_held_trigger_fired[action] = false # Reset the "fire once" flag for this new press.

		if just_released:
			if not _held_trigger_fired.get(action, false): # for this press now, agar action fire nhi hua, then it must mean that it was released too early
				_short_press_released[action] = true #basically counts a light press (this is relative to what you consider as a long press)
			
			# 3. Clean up the press data for this action now that it's over.
			_press_start_frame.erase(action)
			_held_trigger_fired.erase(action)

func was_action_held_for(action: String, hold_frames: int) -> bool:
	# Quick exit checks for performance
	if not Input.is_action_pressed(action) or _held_trigger_fired.get(action, false):
		return false
	
	var current_frame = Engine.get_physics_frames()
	var hold_duration = current_frame - _press_start_frame.get(action, current_frame)
	if hold_duration >= hold_frames:
		_held_trigger_fired[action] = true # This ensures it only returns true once per press.
		return true
		
	return false

## A helper function that pairs perfectly with the above.
## Returns true for ONLY ONE FRAME when a key is released after a SHORT hold(relative to what you give a long hold).
func was_short_press_released(action: String) -> bool:
	return _short_press_released.get(action, false)



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

func horizontal_input() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

# Dynamic remapping
func remap_action(action_name: String, new_event: InputEvent) -> void:
	if not InputMap.has_action(action_name):
		push_warning("Trying to remap undefined input: %s" % action_name)
		return
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, new_event)


func was_triggered_recently(action_name: String, window: int) -> bool: #to check if the key was pressed anytime before in past window(int) frames
	if not _last_pressed_frame.has(action_name):
		return false
		
	var frames_since_press = Engine.get_physics_frames() - _last_pressed_frame[action_name]
	return frames_since_press <= window
