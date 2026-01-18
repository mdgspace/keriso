extends Node

const SAVE_PATH := "user://savegame.json"

var _saveables: Dictionary = {}  # save_id -> Saveable

# -------------------------
# Registration
# -------------------------
func register_saveable(saveable: Object) -> void:
	if not saveable.has_method("get_save_data") \
	or not saveable.has_method("load_save_data"):
		push_warning("Object %s is not saveable" % saveable)
		return

	if not ("save_id" in saveable):
		push_warning("Saveable missing save_id: %s" % saveable)
		return

	_saveables[saveable.save_id] = saveable

# -------------------------
# Save
# -------------------------
func save_game() -> void:
	var data: Dictionary = {}

	for id in _saveables.keys():
		data[id] = _saveables[id].get_save_data()

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		push_error("Failed to open save file")
		return

	file.store_string(JSON.stringify(data, "\t"))
	file.close()

	print("Game saved → ", SAVE_PATH)

# -------------------------
# Load
# -------------------------
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		push_warning("No save file found")
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to open save file")
		return

	var result :Variant = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(result) != TYPE_DICTIONARY:
		push_error("Invalid save file format")
		return

	for id in result.keys():
		if _saveables.has(id):
			_saveables[id].load_save_data(result[id])
		else:
			push_warning("Unmatched save_id: %s" % id)

	print("Game loaded")
