extends CharacterBody2D

@export var playerBullet : PackedScene

signal on_chunk_changed
signal stamina_changed
signal health_changed

@export var tile_size = 32
@export var chunk_size = 32

@export var maxHealth = 100
@export var currentHealth:int
@export var healthRegen = 1
@export var speed = 200
@export var maxStamina = 100
@export var currentStamina:int
@export var dashStaminaCost = 25


@export var run = 1.5
var running = 0
var dashDistance = 600
var dashing:int
var dashRdy:bool
var current_chunk = null
var looking
var ang

func pos_to_chunk(x, y):
	var tile_x = floor(x / tile_size)
	var tile_y = floor(y / tile_size)
	var chunk_x = floor(tile_x / chunk_size)
	var chunk_y = floor(tile_y / chunk_size)
	return Vector2(chunk_x, chunk_y)

func _ready():
	$AnimatedSprite2D.animation = "walking"
	dashRdy =true
	currentHealth = maxHealth
	currentStamina = maxStamina
	stamina_changed.emit(currentStamina,maxStamina)
	health_changed.emit(currentHealth,maxHealth)
	$StaminaRegen.start()
	$HealthRegen.start()
	current_chunk = pos_to_chunk(position.x, position.y)
	on_chunk_changed.emit(current_chunk)

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("running") && currentStamina > 0:
		$StaminaRegen.stop()
		running = 1
		currentStamina += -1 #maybe multiply by delta
		stamina_changed.emit(currentStamina,maxStamina)
		$StaminaRegen.wait_time=1
		$StaminaRegen.start()
		$StaminaRegen.wait_time=.05
	
	velocity = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	if velocity.length() > 0:
		move_and_collide(velocity)
		velocity = velocity * speed
		if dashing == 0:
			$AnimatedSprite2D.animation = "walking"
			$AnimatedSprite2D.play()
		
	elif velocity.length() == 0  && dashing == 0:
		$AnimatedSprite2D.stop()
		
		
	if running >0:
		position += (velocity*running*run) * delta
	else:
		position += (velocity) * delta
	
	#where is the player looking?
	looking = Input.get_vector("look_left","look_right","look_up","look_down")
	ang = looking.angle()
	rotation = ang
	
	#logic for shooting
	if Input.is_action_pressed("shoot"):
		var new_bullet = playerBullet.instantiate()
		new_bullet.position = looking
		
		
		add_child(new_bullet)
	
	#logic for dashing
	if dashRdy == true && Input.is_action_just_pressed("dash") && currentStamina > dashStaminaCost:
		$StaminaRegen.stop()
		$Area2D/DamageCollisionShape2D.disabled = true
		currentStamina += -dashStaminaCost
		stamina_changed.emit(currentStamina,maxStamina)
		dashing = 10
		$StaminaRegen.wait_time=1
		$StaminaRegen.start()
		$StaminaRegen.wait_time=.05
		dashRdy = false
		$DashWait.start()
		$AnimatedSprite2D.animation = "dashing"
		$AnimatedSprite2D.play()
	if dashing > 0:
		dashing += -1
		position += velocity.normalized()*dashDistance*delta
		$AnimatedSprite2D.animation = "dashing"
		$AnimatedSprite2D.play()
		if dashing == 0:
			$Area2D/DamageCollisionShape2D.disabled = false

	#if running slow down
	if running > 0:
		running =+ -.01
	else:
		running = 0
	
	var chunk_id = pos_to_chunk(position.x, position.y)
	
	if current_chunk.x != chunk_id.x || current_chunk.y != chunk_id.y:
		current_chunk = chunk_id
		on_chunk_changed.emit(current_chunk)

	
	
func _on_stamina_regen_timeout() -> void:
	if currentStamina <maxStamina:
		currentStamina += 1
		stamina_changed.emit(currentStamina,maxStamina)

func _on_health_regen_timeout() -> void:
	if currentHealth < maxHealth:
		currentHealth += healthRegen
		health_changed.emit(currentHealth,maxHealth)
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	currentHealth += -10
	health_changed.emit(currentHealth,maxHealth)
	pass # Replace with function body.

func _on_dash_wait_timeout() -> void:
	dashRdy =true
	pass # Replace with function body.
