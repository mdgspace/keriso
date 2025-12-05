extends Area2D

@export var max_health: int = 100
var current_health: int = max_health

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int, applyknockback:bool,knockback: Vector2) -> void:
	current_health -= amount
	print("Hurtbox: Took", amount, "damage. Remaining HP:", current_health)
	

	# Apply knockback (optional)
	if(applyknockback):
		apply_knockback(knockback)

	# Check if dead
	if current_health <= 0:
		die()

func apply_knockback(force: Vector2) -> void:
	#print("Applying knockback")
	# Apply knockback to parent node (e.g., CharacterBody2D)
	var parent = get_parent()
	if parent and parent.has_method("apply_knockback"):
		parent.apply_knockback(force)


func die() -> void:
	var parent = get_parent()
	parent.queue_free()
