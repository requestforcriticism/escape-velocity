extends CharacterBody2D

signal on_chunk_changed
signal stamina

@export var tile_size = 32
@export var chunk_size = 32

@export var health = 3
@export var speed = 200
@export var maxStamina = 100
@export var currentStamina = 50

@export var run = 1.5
var running = 0


var current_chunk = null

func pos_to_chunk(x, y):
	var tile_x = floor(x / tile_size)
	var tile_y = floor(y / tile_size)
	var chunk_x = floor(tile_x / chunk_size)
	var chunk_y = floor(tile_y / chunk_size)
	return Vector2(chunk_x, chunk_y)

func _ready():
	$StaminaRegen.start()
	current_chunk = pos_to_chunk(position.x, position.y)
	on_chunk_changed.emit(current_chunk)

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	#var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_pressed("running") && currentStamina > 0:
		$StaminaRegen.stop()
		running = 1
		currentStamina += -1 #maybe multiply by delta
		stamina.emit(currentStamina)
		$StaminaRegen.wait_time=1
		$StaminaRegen.start()
		$StaminaRegen.wait_time=.05
		

	velocity = Input.get_vector("move_left","move_right","move_up","move_down")	
	print(velocity)
	if velocity.length() > 0:
		move_and_collide(velocity)
		velocity = velocity * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if running >0:
		position += (velocity*running*run) * delta
	else:
		position += (velocity) * delta
		
	var ang = velocity.angle()
	rotation = ang
	#if velocity.x != 0:
		#$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		## See the note below about the following boolean assignment.
		#$AnimatedSprite2D.flip_h = velocity.x < 0
	#elif velocity.y != 0:
		#$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0
	
	if running > 0:
		running =+ -.01
	else:
		running = 0
	
	
	var chunk_id = pos_to_chunk(position.x, position.y)
	
	if current_chunk.x != chunk_id.x || current_chunk.y != chunk_id.y:
		current_chunk = chunk_id
		on_chunk_changed.emit(current_chunk)

	
	
	
	
	
	
	#print("Pos X: ", snapped(position.x, 0.1), 
		#"\tY: ", snapped(position.y, 0.1), 
		#"\tTx: ", snapped(position.x, 1) / tile_size,
		#"\tTy: ", snapped(position.y, 1) / tile_size,
		#"\tCx: ", chunk_id.x,
		#"\tCy: ", chunk_id.y)
func _on_stamina_regen_timeout() -> void:
	if currentStamina <maxStamina:
		currentStamina += 1
		stamina.emit(currentStamina)
	pass # Replace with function body.
