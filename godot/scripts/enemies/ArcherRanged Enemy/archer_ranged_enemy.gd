class_name archer_ranged_enemy extends Enemy

@export var arrow_scene: PackedScene
@export var shoot_point: Node2D
@export var arrow_speed := 300.0
var direction: Vector2

func perform_attack() -> void:
	shoot_arrow()


func shoot_arrow() -> void:
	if arrow_scene == null:
		push_error("Arrow scene not assigned")
		return

	var arrow = arrow_scene.instantiate()
	arrow.global_position = shoot_point.global_position+ Vector2(80,-10)
	print("Shooting arrow from position",arrow.global_position)
	if _facing == Facing.RIGHT:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

	arrow.velocity = direction * arrow_speed

	get_tree().current_scene.add_child(arrow)
