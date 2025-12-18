extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.visible = false
	label_ref.text = labelText
	checkpt.text = checkptDescription
@onready var area_2d: Area2D = $Area2D
@onready var label_ref = $Area2D/Control/ColorRect/Label
@onready var checkpt: Label = $Checkpt
@export var labelText = ""
@export var checkptDescription = ""
var enemy1 := preload("res://scenes/enemies/kunoichi_enemy.tscn")
var enemy2 := preload("res://scenes/enemies/samurai_dash_enemy.tscn")
var enemy_yet_to_spawn = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entered ", body)
	if body.is_in_group("Player"):
		print(body)
		area_2d.visible = true
		if checkptDescription == "Checkpt1":
			NarratorGlobal.advance_phase()
		elif checkptDescription == "Checkpt2":
			spawn_enemy_once()




func _on_area_2d_body_exited(body: Node2D) -> void:
	print("entered ", body)
	if body.is_in_group("Player"):
		print(body)
		area_2d.visible = false

func spawn_enemy_once():
	if !enemy_yet_to_spawn:
		return
	enemy_yet_to_spawn = false
	var player = PlayerGlobal.player_instance
	if player == null:
		return

	var player_pos = player.CharacterBody.global_position

	var enemy1_scene = enemy1.instantiate()
	var enemy2_scene = enemy2.instantiate()

	enemy1_scene.global_position = player_pos + Vector2(-200, 0)
	enemy2_scene.global_position = player_pos + Vector2(200, 0)

	get_tree().current_scene.add_child(enemy1_scene)
	get_tree().current_scene.add_child(enemy2_scene)
