extends CharacterBody2D

signal on_die

const SPEED = 300.0
const JUMP_VELOCITY = 600.0

enum MONSTER_STATE {PASSIVE, SEARCHING, ATTACKING, POUNCING, DEAD}
var state = MONSTER_STATE.PASSIVE
var target : Node2D
var current_wander_target : Node2D

var wander_target : PackedScene = load("res://entities/base_monster/wander_target.tscn")
@export var patrol_speed = 150
@export var chase_speed = 200
@export var attack_speed = 400
@export var player : Node2D = null
var col_scn : PackedScene = load("res://components/Collectables/collectables.tscn")

@export var timeratio = 1
@export var max_hp : int = 25
@export var damage:int
var hp

var speed = patrol_speed

func _ready():
	print("damage: ",damage)
	#print("hp: ",max_hp )
	hp = max_hp
	$HealthBar.max_value = max_hp
	$HealthBar.value = max_hp
	$HealthBar.modulate = Color.RED
	
func on_damage(bullet):
	if "damage" in bullet:
		hp -= bullet.damage
		$HealthBar.value = hp
		#print("hit for, ", bullet.damage, " now at ", hp)
		#bullet.queue_free()
	if hp <= 0:
		Save.set_value(1, "MONDEF", Save.get_value(1, "MONDEF", 0)+1)
		
		if randf_range(0,max(50/timeratio,8)) < 9:
			for i in 1:
				var drop = col_scn.instantiate()
				drop.type = "FOO"
				drop.position = position
				add_sibling(drop)
		on_die.emit()
		queue_free()

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
		pass
	
		
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
	target = body
	$AttackTimer.start()

# player leaves aggro range
func _on_chase_area_body_exited(body):
	state = MONSTER_STATE.PASSIVE
	target = null

# player leaves attack range
func _on_attack_area_body_exited(body):
	state = MONSTER_STATE.SEARCHING
	$AttackTimer.stop()

# start persuing player 
func _on_search_area_body_entered(body):
	state = MONSTER_STATE.SEARCHING
	if target == current_wander_target && current_wander_target != null:
		current_wander_target.queue_free()
	target = body
	#if(player == null):
		#attack(target)
	#else:
		#attack(player)

func _on_wander_radius_body_entered(body):
	if body == self and state == MONSTER_STATE.PASSIVE:
		$WanderExpireTimer.stop()
		target.queue_free()
		get_next_wander_location()


func _on_wander_expire_timer_timeout():
	if current_wander_target != null:
		current_wander_target.queue_free()
	if target != player or state == MONSTER_STATE.SEARCHING:
		get_next_wander_location()

func attack(body):
	#print("attacking")
	pass

func _on_attack_timer_timeout() -> void:
	if(player == null):
		attack(target)
	else:
		attack(player)
	pass # Replace with function body.
