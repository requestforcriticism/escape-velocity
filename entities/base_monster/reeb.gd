extends "res://entities/base_monster/base_monster.gd"

var pouncing:bool
var pouncerdy:bool = true

func _process(delta):
	if state == MONSTER_STATE.PASSIVE:
		speed = patrol_speed
		if target == null:
			get_next_wander_location()
		move_to_target()
	elif state == MONSTER_STATE.SEARCHING and target != null:
		speed = chase_speed
		move_to_target()
	elif state == MONSTER_STATE.ATTACKING:
		speed = attack_speed
	elif state == MONSTER_STATE.POUNCING:
		#print(velocity.normalized()*delta*JUMP_VELOCITY)
		global_position -= velocity.normalized()*delta*JUMP_VELOCITY

func attack(target):
	if pouncerdy:
		state = MONSTER_STATE.POUNCING
		if !pouncing:
			velocity = (global_position-target.global_position).normalized()
		$PounceTimer.start()
		pouncing = true
		$CollisionShape2D.disabled = true
	else:
		state = MONSTER_STATE.SEARCHING
	#$AttackTimer.stop()

var Pcount = 0
func _on_pounce_timer_timeout() -> void:
	Pcount += 1
	if Pcount >= 20 && pouncing:
		state = MONSTER_STATE.SEARCHING
		Pcount = 0
		pouncing = false
		pouncerdy = false
		$CollisionShape2D.disabled = false
		$PounceCD.start()

func _on_pounce_cd_timeout() -> void:
	pouncerdy = true
	
	
	
#func pounce():
	#if player != null:
		#position = player.position
		#player.damage_player(damage)
	#$AttackTimer.start()

#func _on_attack_area_body_exited(body):
	#super._on_attack_area_body_exited(body)
	#$PounceTimer.stop()
