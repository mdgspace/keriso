extends Area2D

signal enemy_health_changed(current_health: int, max_health: int)

@export var max_health: int = 100
var current_health: int

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int, apply_knockback: bool, knockback: Vector2) -> void:
	if current_health <= 0:
		return # already ded, ignore

	current_health -= amount
	current_health = max(current_health, 0)

	emit_signal("enemy_health_changed", current_health, max_health)
	print("Enemy Take Damage","Remaining Health",current_health)
	if apply_knockback:
		apply_knockback_to_parent(knockback)

	if current_health == 0:
		die()

func apply_knockback_to_parent(force: Vector2) -> void:
	var parent = get_parent()
	if parent and parent.has_method("apply_knockback"):
		parent.apply_knockback(force)

func die() -> void:
	var parent = get_parent()
	if parent:
		parent.queue_free()
