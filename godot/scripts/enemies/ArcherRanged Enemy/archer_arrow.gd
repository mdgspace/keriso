extends Node2D
class_name ArcherArrow

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
