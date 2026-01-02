class_name archer_ranged_enemy extends Enemy

@export var arrow_scene: PackedScene
@export var shoot_point: Node2D
@export var arrow_speed := 600.0
var direction:float
func perform_attack() -> void:
	shoot_arrow()


func shoot_arrow() -> void:
	if arrow_scene == null:
		push_error("Arrow scene not assigned")
		return

	var arrow = arrow_scene.instantiate()
	arrow.global_position = shoot_point.global_position

	if _facing == Facing.RIGHT:
		direction =1
	else:
		direction = -1
	
		
	arrow.velocity = direction * arrow_speed

	get_tree().current_scene.add_child(arrow)
