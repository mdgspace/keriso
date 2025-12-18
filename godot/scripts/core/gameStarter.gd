extends Node2D
var player_camera_scene := preload("res://scenes/world/Camera.tscn")
var narrator = NarratorGlobal
@onready var sword: Sprite2D = $Sword2
var t := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.BLACK
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
		narrator.play_current_phase()

func _process(delta: float) -> void:
	if t < 1.0:
		t += delta / 20
		t = clamp(t, 0.0, 1.0)
		modulate = Color(t, t, t, 1.0)
	#var Skew = sword.skew 
	#var Max_Skew = deg_to_rad(89.9)
	#var player_pos_x = PlayerGlobal.player_instance.CharacterBody.position.x
	#if Skew > Max_Skew:
		#Skew = -Max_Skew
	#else:
		#Skew+=delta*2
	#sword.skew = Skew
	#if player_pos_x >= 275:
		#narrator.advance_phase()
		#sword.position = sword.position.move_toward(Vector2(280,-40), 50 * delta)
	#
	#if sword.position.distance_to(Vector2(280, -40)) < 0.01:
		#sword.queue_free() # Safely deletes the sword node from the scene
