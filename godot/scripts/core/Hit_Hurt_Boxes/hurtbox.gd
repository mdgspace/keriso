extends Area2D

@export var max_health: int = 100
var current_health: int = max_health
var is_invincible: bool = false
var invincibility_duration: float = 0.5  # seconds

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int, knockback: Vector2) -> void:
	if is_invincible:
		return
	
	current_health -= amount
	print("Hurtbox: Took", amount, "damage. Remaining HP:", current_health)

	# Apply knockback (optional, depends on how your player is structured)
	apply_knockback(knockback)
	var parent = get_parent()
	if parent and parent.has_method("taken_damage"):
		parent.taken_damage()
	## Set invincibility to prevent multiple hits instantly
	#start_invincibility()

	# Check if dead
	if current_health <= 0:
		die()

func apply_knockback(force: Vector2) -> void:
	# Apply knockback to parent node (e.g., CharacterBody2D)
	var parent = get_parent()
	if parent and parent.has_method("apply_knockback"):
		parent.apply_knockback(force)

func start_invincibility() -> void:
	is_invincible = true
	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false

func die() -> void:
	print("Hurtbox: Dead!")
