extends Node2D
class_name ArcherArrow

var velocity: Vector2 = Vector2.ZERO
@export var impact_effect: PackedScene

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	
func _ready():
	$Area2D.damage_dealt.connect(_on_damage_dealt)

func _on_damage_dealt(target, _damage, _knockback):
	spawn_impact_effect(target)
	
func spawn_impact_effect(target:Area2D):
	if impact_effect == null:
		print("Impact Effect nulll")
		return

	var effect = impact_effect.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = target.global_position
