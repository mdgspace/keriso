extends Saveable

@export var quests: Array[QuestResource] = []


signal quest_completed(quest_id)
signal objective_updated(quest_id, objective_index, current, required)

func _ready() -> void:
	if save_id == "":
		save_id = "quest_manager"

func update_quests(event: String, value: String) -> void: # Pass in objective type and objective target
	for quest in quests:
		if quest.status == QuestResource.QuestStatus.ACTIVE:
			for i in range(quest.objectives.size()):
				var obj = quest.objectives[i]
				var before = obj.current
				obj.update(event, value)
				if obj.current != before:
					emit_signal("objective_updated", quest.id, i, obj.current, obj.required)

			if quest.is_complete():
				quest.status = QuestResource.QuestStatus.COMPLETE
				emit_signal("quest_completed", quest.id)


func get_save_data() -> Dictionary:
	var data := {}
	for quest in quests:
		var quest_data = {
			"id": quest.id,
			"status": int(quest.status),
			"objectives": []
		}
		for obj in quest.objectives:
			quest_data["objectives"].append({
				"type": obj.type,
				"target": obj.target,
				"required": obj.required,
				"current": obj.current
			})
		data[quest.id] = quest_data
	return data

func load_save_data(data: Dictionary) -> void:
	for quest in quests:
		if data.has(quest.id):
			var qd = data[quest.id]
			quest.status = int(qd["status"])
			for i in range(len(quest.objectives)):
				if i < len(qd["objectives"]):
					quest.objectives[i].current = qd["objectives"][i]["current"]
