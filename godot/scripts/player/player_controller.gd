class_name PlayerController extends CharacterBody2D


enum Facing {
	LEFT,
	RIGHT
}

var horizontal_input: float = 0
var was_on_floor 
var _facing: Facing = Facing.RIGHT
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animatedsprite2d = $AnimatedSprite2D
@onready var movement_state_machine = $MovementStateMachine
@onready var action_state_machine = $ActionStateMachine

@onready var InteractUI = $InteractUI
@onready var InventoryUI = $Inventory

#@onready var movement_state_machine = $MovementStateMachine

func _ready() -> void:
	InventoryManager.set_player_ref(self)
	var movement_states: Array[State] = [PlayerIdleState.new(self), PlayerMovementState.new(self), PlayerJumpState.new(self)]
	var action_states: Array[State] = [PlayerAttackState.new(self),PlayerParryState.new(self),PlayerDefenseState.new(self)]
	movement_state_machine.start_machine(movement_states)
	action_state_machine.start_machine(action_states)

func _physics_process(delta: float) -> void:	
	horizontal_input = InputNode.horizontal_input()

	# Always apply gravity
	if not is_on_floor():
		velocity.y += _gravity * delta
		
	if not is_on_floor() and was_on_floor:
		movement_state_machine.transition("PlayerJumpState")

	was_on_floor = is_on_floor()
	move_and_slide()
	
	
func handle_facing() -> void:
	var flip: int = 0
	
	if horizontal_input < 0.0:
		flip = 1
	elif horizontal_input > 0.0:
		flip = -1

	# Apply facing
	var _old_facing: Facing = _facing
	
	if flip == -1:
		animatedsprite2d.flip_h = false
		_facing = Facing.RIGHT
	elif flip == 1:
		animatedsprite2d.flip_h = true
		_facing = Facing.LEFT	
		
		
func apply_item_effect(item):
	match item["item_type"]:
		"consumable":
			match item["item_effect"]:
				"heal":
					print("increasing stamina")
					return 1;
			return 0; # Returning the number of items to be consumed
		"permanent_item":
			pass
			return 0;  # If it's a permanent item like homeward idol, we can return 0
		"quest_item":
			pass
			# use function to call quest status update using data in item.
			# change item's definition to support this (to have metadata about quest)
			return item["quantity"];  # In quests like deliver items, all the quest item
			# gets consumed. Instead of this, make the quest status update itself return 
			# the variable of items being consumed and return that here.
