class_name EnemyAttack2State extends EnemyState
var distance: float 
var timer: float
func enter() -> void:
	enemy.velocity.x=0
	#timer = enemy.attack_cooldown
	#animatedsprite2d.play("Walk")
	animatedsprite2d.play("Attack2")

func physics_process(delta: float) -> void:
	#if timer <=0:
		#animatedsprite2d.play("Attack2")
	#timer-=delta
	distance = enemy.to_player.length()
	enemy.handle_facing()
	if distance > enemy.attack_range && enemy.anim_finished: #changed || to &&
		movement_state_machine.transition("EnemyIdleState")
	
func get_state_name() -> String:
	return "EnemyAttack2State"
