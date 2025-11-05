@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("QuestResource", "Resource", preload("res://addons/quest_manager/resources/quest_resource.gd"), null)
	add_custom_type("ObjectiveResource", "Resource", preload("res://addons/quest_manager/resources/objective_resource.gd"), null)

func _exit_tree():
	remove_custom_type("QuestResource")
	remove_custom_type("ObjectiveResource")
