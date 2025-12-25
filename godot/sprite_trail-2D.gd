extends Node
class_name SpriteTrail2D

@export var source_sprite: Sprite2D
@export var player: PlayerController

# ---- Pool Settings ----
@export var pool_size := 10
@export var frame_interval := 6
@export var min_velocity := 10.0
@export var lifetime := 0.35
@export var pixel_snap := true

# ---- Visuals ----
@export var start_color := Color(1, 0.3, 0.3, 0.8)
@export var end_color := Color(1, 0.3, 0.3, 0.0)

# ---- Internal ----
var sprite_pool: Array[Sprite2D] = []
var _frame_counter := 0
var _active := false

func _ready() -> void:
	_setup_sprite_pool()

func start_trail() -> void:
	_active = true
	_frame_counter = 0

func stop_trail() -> void:
	_active = false

	# Hard reset all ghosts
	for ghost in sprite_pool:
		if is_instance_valid(ghost):
			ghost.visible = false
			ghost.modulate.a = start_color.a

func _setup_sprite_pool() -> void:
	sprite_pool.clear()

	for i in pool_size:
		var ghost: Sprite2D = source_sprite.duplicate()
		ghost.visible = false
		ghost.z_index = source_sprite.z_index - 1
		get_tree().root.add_child.call_deferred(ghost)
		sprite_pool.append(ghost)

func _process(_delta: float) -> void:
	if not _active:
		return

	# ---- Movement gating ----
	if player.velocity.length() < min_velocity:
		return

	_frame_counter += 1
	if _frame_counter % frame_interval != 0:
		return

	_emit_trail()

func _emit_trail() -> void:
	if sprite_pool.is_empty():
		return

	var ghost: Sprite2D = sprite_pool.pop_front()

	# ---- Frame sync (spritesheet) ----
	ghost.frame = source_sprite.frame

	# ---- Transform sync (CRITICAL) ----
	ghost.flip_h = source_sprite.flip_h
	ghost.flip_v = source_sprite.flip_v
	ghost.scale = source_sprite.scale
	ghost.scale = player.scale/2.5
	ghost.rotation = source_sprite.rotation
	ghost.offset = source_sprite.offset + Vector2(0,-18)

	# ---- Position ----
	var pos: Vector2 = player.global_position + source_sprite.position
	if pixel_snap:
		pos = pos.round()
	ghost.global_position = pos

	# ---- Color by age ----
	var t := float(sprite_pool.size()) / pool_size
	ghost.modulate = start_color.lerp(end_color, t)
	ghost.visible = true

	# ---- Fade (pool-safe) ----
	var tween := ghost.create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, lifetime)
	tween.tween_callback(func():
		ghost.visible = false
		sprite_pool.append(ghost)
	)
