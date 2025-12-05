class_name samurai_dash_enemy extends Enemy

func apply_knockback(knockback: Vector2) -> void:
	velocity = knockback
