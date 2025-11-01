#extends Area2D
#
#@export var max_health: int = 100
#var current_health: int = max_health
#var is_invincible: bool = false
#
#func _ready() -> void:
	#current_health = max_health
#
#func take_damage(amount: int, applyknockback:bool,knockback: Vector2) -> void:
	#if is_invincible:
		#return
	#
	#current_health -= amount
	#print("Hurtbox: Took", amount, "damage. Remaining HP:", current_health)
#
	## Apply knockback (optional)
	#if(applyknockback):
		#apply_knockback(knockback)
	#var parent = get_parent()
	#if parent and parent.has_method("taken_damage"):
		#parent.taken_damage()
#
	## Check if dead
	#if current_health <= 0:
		#die()
#
#func apply_knockback(force: Vector2) -> void:
	##print("Applying knockback")
	## Apply knockback to parent node (e.g., CharacterBody2D)
	#var parent = get_parent()
	#if parent and parent.has_method("apply_knockback"):
		#parent.apply_knockback(force)
#
#
#func die() -> void:
	#print("Hurtbox: Dead!")
class_name PlayerHurtbox
extends Area2D

@export var max_health: float = 100.0
var current_health: float
var is_invincible: bool = false

@onready var owner_player: PlayerControllerTest = owner

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float, apply_knockback: bool, knockback: Vector2) -> void:
	if is_invincible:
		return

	current_health = max(0, current_health - amount)
	print("[HURTBOX]: Took %.1f damage → %.1f HP left" % [amount, current_health])

	# Apply knockback via PlayerController if possible
	if owner_player != null:
		if apply_knockback and owner_player.has_method("apply_knockback"):
			owner_player.apply_knockback(knockback)
		if owner_player.has_method("taken_damage"):
			owner_player.taken_damage()
	else:
		# Fallback if no owner assigned
		if apply_knockback:
			apply_knockback_self(knockback)

	if current_health <= 0:
		die()

func apply_knockback_self(force: Vector2) -> void:
	print("[HURTBOX]: Knockback fallback:", force)

func die() -> void:
	print("[HURTBOX]: Dead!")
