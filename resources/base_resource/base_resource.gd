extends StaticBody2D

signal health_changed

@export var bullet_scene : PackedScene
@export var maxHealth = 100
@export var currentHealth:int
@export var healthRegen = 1
@export var drop: PackedScene
@export var drop_count = 1
@export var durability = 5 #secs to mine
@export var max_drops = 10

var mined_drops = 0 #num resources mined so fat
var miners = []

enum RESOURCE_STATE { AGGESSIVE , PASSIVE , MINED , DEAD }

@export var state : RESOURCE_STATE

var shoot_state = 0

func mine(miner):
	
	if state == RESOURCE_STATE.DEAD or state == RESOURCE_STATE.AGGESSIVE:
		return [0, null]
	elif state == RESOURCE_STATE.PASSIVE:
		state = RESOURCE_STATE.MINED
		$AnimatedSprite2D.play("mined")
		
	#resource should be mineable now
	mined_drops += 1
	
	# if resource already at max
	if mined_drops >= max_drops:
		state = RESOURCE_STATE.DEAD
		$AnimatedSprite2D.play("depleted")
	
	#otherwise add miner to list of subscribers
	if !miners.has(miner):
		miners.push_back(miner)
		
	return [durability, drop]

# Called when the node enters the scene tree for the first time.
func _ready():
	currentHealth = maxHealth
	$HealthBar.value = currentHealth
	$AnimatedSprite2D.play("default")
	state = RESOURCE_STATE.AGGESSIVE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == RESOURCE_STATE.AGGESSIVE and currentHealth <=0:
		$AnimatedSprite2D.play("tamed")
		state = RESOURCE_STATE.PASSIVE
		$HealthBar.queue_free()
		$Timer.stop()
		$Area2D.queue_free()
	
func attack():
	var shoot_angle = deg_to_rad((shoot_state * 90) % 360)
	shoot_bullet(shoot_angle, 1, 10, 1)
	shoot_state += 1

func shoot_bullet(angle, expiration, damage, size):
	var bullet = bullet_scene.instantiate()
	var velocity = Vector2(150.0, 0.0)
	bullet.direction = Vector2.RIGHT.rotated(angle)
	add_child(bullet)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if state == RESOURCE_STATE.AGGESSIVE:
		print("print bguy")
		currentHealth += -10
		$HealthBar.value = currentHealth
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color.WHITE

# demo func based on harvester
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.get_class() == "InputEventMouseButton" and event.pressed:
		var mine_ref = mine(null)
		print("Mining this, durab\t", mine_ref[0], "\tRef\t",mine_ref[1])