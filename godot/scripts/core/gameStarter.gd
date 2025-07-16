extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerGlobal.player_instance == null:
		var player = PlayerGlobal.player_scene.instantiate()
		add_child(player)
		PlayerGlobal.player_instance = player
		print("Instantiated player")
		var dengey = PlayerGlobal.player_instance
		print(dengey);


# Called every frame. 'delta' is the elapsed time since the previous frame.
