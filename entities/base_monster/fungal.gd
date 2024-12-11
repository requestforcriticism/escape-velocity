extends "res://entities/base_monster/base_monster.gd"

var bullet : PackedScene = load("res://components/bullet/bullet.tscn")



func attack(target):
	$SplodeTimer.start()

var is_offset=false

func splode():
	#print("fungal attacking")
	var num_balls = 8
	var splosion_angle = TAU / num_balls
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	
	var offset = splosion_angle/2
	
	for i in range(num_balls):
		var new_bullet = bullet.instantiate()
		#new_bullet.position = position
		#var direction = (i * splosion_angle)
		##new_bullet.linear_velocity = velocity.rotated(direction)
		#new_bullet.direction = Vector2.RIGHT.rotated(direction)
		#add_child(new_bullet)
		#var bullet = bullet_scene.instantiate()
		var vel = Vector2(150.0, 0.0)
		new_bullet.damage = damage
		new_bullet.modulate = Color.RED
		if is_offset:
			new_bullet.direction = Vector2.RIGHT.rotated(splosion_angle * i + offset)
		else:
			new_bullet.direction = Vector2.RIGHT.rotated(splosion_angle * i)
		add_child(new_bullet)
		#print("added bullet")
	is_offset = !is_offset

func _on_attack_area_body_exited(body):
	$SplodeTimer.stop()
	super._on_attack_area_body_exited(body)
	#stop shooting
