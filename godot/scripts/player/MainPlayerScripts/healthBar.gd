extends ProgressBar
var player
var hurtbox
func _ready() -> void:
	# find the Hurtbox (adjust path as needed)
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	player = PlayerGlobal.player_instance.CharacterBody
	if player:
		hurtbox = player.get_node_or_null("Hurtbox")
	# connect the signal
	if hurtbox:
		hurtbox.health_changed.connect(_on_health_changed)
		# initialize
		_on_health_changed(hurtbox.current_health, hurtbox.max_health)
	else :
		print("hurtbox not found")

func _on_health_changed(current: int, max: int) -> void:
	print("Changing health value to ", float(current) / float(max) * 100.0)
	value = float(current) / float(max) * 100.0
