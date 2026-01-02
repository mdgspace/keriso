extends Node2D

var velocity: Vector2

func _physics_process(delta):
	global_position += velocity * delta
