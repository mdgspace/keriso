extends Node2D
var player_camera_scene := preload("res://scenes/world/Camera.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerGlobal.player_instance == null:
		print("Starting instantiation of player")
		var player = PlayerGlobal.player_scene.instantiate()
		add_child(player)
		PlayerGlobal.player_instance = player
		print("Instantiated player")
		var MainPlayerNode = PlayerGlobal.player_instance.CharacterBody
		var camera = player_camera_scene.instantiate()
		MainPlayerNode.add_child(camera)
		camera.make_current()
		camera.zoom = Vector2(2,2)
		camera.position.y -= 75
