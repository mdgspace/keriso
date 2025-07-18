class_name PlayerHurtState extends PlayerState

static var state_name := "PlayerHurtState"
var timer:float

func enter()->void:
	animatedsprite2d.play("hurt")
	timer = player.hurt_time

func physics_process(delta: float) -> void:
	##Have taken kinda random values currently
	timer-=delta
	if timer<=0:
		movement_state_machine.transition(PlayerIdleState.state_name)	
	if timer <player.stun_time:
		player.velocity.x =0;


func get_state_name() -> String:
	return state_name
