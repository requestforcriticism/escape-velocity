extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum MONSTER_STATE {PASSIVE, SEARCHING, ATTACKING}
var state = MONSTER_STATE.PASSIVE
var target : Node2D
var current_wander_target : Node2D

@export var wander_target : PackedScene
@export var patrol_speed = 150
@export var chase_speed = 200
@export var attack_speed = 400

var speed = patrol_speed

func _physics_process(delta):
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
		
func get_next_wander_location():
	target = wander_target.instantiate()
	target.connect("entered", _on_wander_radius_body_entered)
	target.global_position.x = randf_range(-500, 500) + global_position.x
	target.global_position.y = randf_range(-500, 500)  + global_position.y
	current_wander_target = target
	$WanderExpireTimer.start()
	add_sibling(target)

func move_to_target():
	if target != null:
		var direction = get_angle_to(target.position)
		velocity = Vector2.RIGHT.rotated(direction) * speed
		move_and_slide()

# start attacking the player
func _on_attack_area_body_entered(body):
	state = MONSTER_STATE.ATTACKING
	pass # Replace with function body.

# player leaves aggro range
func _on_chase_area_body_exited(body):
	state = MONSTER_STATE.PASSIVE
	target = null

# player leaves attack range
func _on_attack_area_body_exited(body):
	state = MONSTER_STATE.SEARCHING
	pass # Replace with function body.

# start persuing player 
func _on_search_area_body_entered(body):
	state = MONSTER_STATE.SEARCHING
	if target == current_wander_target:
		current_wander_target.queue_free()
	target = body


func _on_wander_radius_body_entered(body):
	if body == self and state == MONSTER_STATE.PASSIVE:
		$WanderExpireTimer.stop()
		target.queue_free()
		get_next_wander_location()


func _on_wander_expire_timer_timeout():
	if current_wander_target != null:
		current_wander_target.queue_free()
	get_next_wander_location()