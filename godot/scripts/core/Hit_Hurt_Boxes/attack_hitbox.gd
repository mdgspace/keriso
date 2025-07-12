class_name AttackHitBox
extends Area2D

@export var damage: float = 10.0
@export var knockback_force: float = 200.0
@export var knockback_direction: Vector2 = Vector2.ZERO

var has_hit: bool = false
var hit_targets: Array = []

#func _init() -> void:
	#collision_layer = 0  # Don't collide with anything
	#collision_mask = 3   #Player hurtbox currently

func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	
func clear_hit_targets() -> void:
	hit_targets.clear()
	
func _on_area_entered(hurtbox: Area2D) -> void:
	if hurtbox.has_method("take_damage") and not hurtbox in hit_targets:
		hit_targets.append(hurtbox)
		
		# Calculate knockback direction if not set
		var kb_dir = knockback_direction
		if kb_dir == Vector2.ZERO:
			kb_dir = (hurtbox.global_position - global_position).normalized()
		
		# Deal damage
		hurtbox.take_damage(damage, kb_dir * knockback_force)
		
		# Emit signal for additional effects
		emit_signal("hit_target", hurtbox)
	
