@tool
extends Resource
class_name QuestResource

enum QuestStatus { INACTIVE, ACTIVE, COMPLETE }

@export var id: String
@export var name: String
@export var description: String
@export var objectives: Array[ObjectiveResource] = []
@export var rewards: Dictionary = {}
@export var is_main_quest: bool = false
@export var status: QuestStatus = QuestStatus.INACTIVE

func is_complete() -> bool:
	for obj in objectives:
		if not obj.is_complete():
			return false
	return true
