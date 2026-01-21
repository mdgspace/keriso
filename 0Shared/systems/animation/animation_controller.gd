extends Node
class_name AnimationController

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $"../Sprite2D"

func request(anim: StringName, facts: Facts) -> void:
	# ALWAYS update facing
	if facts.input.horizontal != 0:
		sprite_2d.flip_h = facts.input.horizontal > 0

	if anim_player.current_animation != anim:
		anim_player.play(anim)
