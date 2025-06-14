extends Node
class_name SaveManager

var saveables: Dictionary = {}
const savePath := "user://savegame.json"

	
	
func _on_register_saveable(saveable: Node) -> void:
	if not saveable.has_method("get_save_data") or not saveable.has_method("load_save_data"):
		push_warning("Registered node does not implement get_save_data/load_save_data")
		return
	
	var id = saveable.save_id
	if id == "":
		push_warning("Saveable node missing save_id")
		return
	saveables[id] = saveable

func save_game() -> void:
	var data_to_save: Dictionary = {}
	
	for id in saveables.keys():
		var saveable = saveables[id]
		var save_data = saveable.get_save_data()
		data_to_save[id] = save_data
		
		var json_text = JSON.stringify(data_to_save, "\t")
		
		var file = FileAccess.open(savePath, FileAccess.WRITE)
		if file:
			file.store_string(json_text)
			file.close()
			print("game saved to ", savePath)
		else:
			push_error("Failed to open save file for writing")
			
func load_game() -> void:
	if not FileAccess.file_exists(savePath):
		push_warning("No save file found at ", savePath)
		return
	
	var file = FileAccess.open(savePath, FileAccess.READ)
	if not file:
		push_error("error opening file")
		return
	
	var json_text := file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(json_text)
	
	if typeof(result) != TYPE_DICTIONARY:
		push_error("Save file is not valid json or dictionary")
		return
	
	var loaded_data: Dictionary = result
	
	for save_id in loaded_data.keys():
		if saveables.has(save_id):
			var saveable = saveables[save_id]
			var data = loaded_data[save_id]
			saveable.load_save_data(data)
		else:
			push_warning("Save id '%s' not found in current saveables", % save_id)
			
	print("Game loaded successfully")
	
