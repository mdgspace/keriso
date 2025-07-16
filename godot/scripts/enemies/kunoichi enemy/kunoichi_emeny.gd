class_name kunoichi_enemy extends Enemy

func _on_animated_sprite_2d_animation_finished() -> void:
	print("anim finished")
	emit_signal("anim_finished")
