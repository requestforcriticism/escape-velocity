extends "res://entities/base_monster/base_monster.gd"


func attack(target):
	state = MONSTER_STATE.POUNCING
	velocity = Vector2.ZERO
	$PounceTimer.start()
	$AttackTimer.stop()
	pass

func pounce():
	if player != null:
		position = player.position
	$AttackTimer.start()

func _on_attack_area_body_exited(body):
	super._on_attack_area_body_exited(body)
	$PounceTimer.stop()
