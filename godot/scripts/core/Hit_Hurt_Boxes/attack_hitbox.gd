#class_name AttackHitBox
#extends Area2D
#
#@export var damage: float = 10.0
#@export var knockback_force: float = 200.0
#@export var knockback_direction: Vector2 = Vector2.ZERO
#@export var apply_knockback:bool 
#var has_hit: bool = false
#var hit_targets: Array = []
#
##func _init() -> void:
	##collision_layer = 0  # Don't collide with anything
	##collision_mask = 3   #Player hurtbox currently
#
#func _ready() -> void:
	#connect("area_entered", self._on_area_entered)
	#
#func clear_hit_targets() -> void:
	#hit_targets.clear()
	#
#func _on_area_entered(hurtbox: Area2D) -> void:
	##print("Area entered")
	#if hurtbox.has_method("take_damage") and not hurtbox in hit_targets:
		#hit_targets.append(hurtbox)
		#
		## Calculate knockback direction if not set
		#var kb_dir = knockback_direction
		#if kb_dir == Vector2.ZERO:
			#kb_dir = (hurtbox.global_position - global_position).normalized()
		#
		## Deal damage
		#hurtbox.take_damage(damage,apply_knockback,kb_dir * knockback_force)

# AttackHitbox.gd
class_name AttackHitbox
extends Area2D

@export var damage: float = 10.0
@export var knockback_force: float = 200.0
@export var knockback_direction: Vector2 = Vector2.ZERO
@export var apply_knockback: bool = true

var hit_targets: Array[Node] = []

func _ready() -> void:
	if not is_connected("area_entered", _on_area_entered):
		connect("area_entered", _on_area_entered)

func clear_hit_targets() -> void:
	hit_targets.clear()

func _on_area_entered(hurtbox: Area2D) -> void:
	if hurtbox in hit_targets:
		return
	if not hurtbox.has_method("take_damage"):
		return

	hit_targets.append(hurtbox)
	var kb_dir = knockback_direction if knockback_direction != Vector2.ZERO else (hurtbox.global_position - global_position).normalized()
	hurtbox.take_damage(damage, apply_knockback, kb_dir * knockback_force)
