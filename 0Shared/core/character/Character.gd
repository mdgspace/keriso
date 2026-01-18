extends CharacterBody2D
class_name Character

@export var move_speed := 200.0
@export var gravity := 900.0
@onready var inventory: InventoryComponent = $InventoryComponent

var brain: Brain
var facts := Facts.new()

func _ready() -> void:
	InputService.input_snapshot_ready.connect(_on_input_snapshot)

func _on_input_snapshot(snapshot: InputSnapshot) -> void:
	velocity.x = 0.0
	
	facts.input = snapshot
	facts.velocity = velocity
	facts.is_on_floor = is_on_floor()
	facts.frame = Engine.get_physics_frames()
	facts.inventory_items = inventory.state.items

	brain.tick(facts)

func _execute_intent(intent: Intent) -> void:
	match intent.type:
		Intent.Type.MOVE:
			velocity.x = intent.move_axis * move_speed
		
		Intent.Type.JUMP:
			if is_on_floor():
				velocity.y = -400
		
		Intent.Type.CHANGE_STATE:
			brain.change_state(intent.target_state, facts)
		Intent.Type.USE_ITEM:
			inventory.consume_item(intent.item_id)

func _physics_process(delta: float) -> void:
	# Gravity (always physics-owned)
	if not is_on_floor():
		velocity.y += gravity * delta * 0
	
	print(velocity)
	# Apply motion ONCE per frame
	move_and_slide()
