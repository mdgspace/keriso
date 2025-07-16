class_name PlayerHurtState extends PlayerState

static var state_name := "PlayerHurtState"
var timer:float

func enter()->void:
	animatedsprite2d.play("hurt")
	timer = 0.3

func physics_process(delta: float) -> void:
	timer-=delta
	if timer<=0:
		movement_state_machine.transition(PlayerIdleState.state_name)	
	


func get_state_name() -> String:
	return state_name
