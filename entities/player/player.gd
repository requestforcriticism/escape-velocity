extends CharacterBody2D

@export_group("External Scenes")
@export var playerBullet : PackedScene
@export var harvester_scene : PackedScene
@export var main_scn : Node
@export var ship_scn : Node

signal on_chunk_changed
signal stamina_changed
signal health_changed
signal gathered
signal hpPackCount
signal consumCount
signal toggleConsum


@export_group("Procgen Properties")
@export var tile_size = 32
@export var chunk_size = 32

@export_group("Player Stats")
@export var maxHealth = 100
@export var currentHealth:int
@export var healthRegen = 0  #A techtree upgrade may improve this.
@export var speed = 200
@export var maxStamina = 100
@export var currentStamina:int
@export var dashStaminaCost = 25
@export var resourceA:int

@export_group("consumables")
@export var Healthpacks:int #healthPack amounts
@export var consum = [0,0,0]  #consumable amounts [ stamina recovery, damage boost, damage reduction]

@export var current_harverters:int
@export var max_harvesters:int


@export var DMG:int

#type of collectables [blue,red,green,yellow,orange,purple]
@export var colable = [0,0,0,0,0,0]
var colnames = ["BLU","IRO","OIL","WAT","URA"]

@export var run = 2
@export var harvester_throw_distance = 200

var running = 0
var dashDistance = 600
var dashing:int
var dashRdy:bool
var current_chunk = null
var looking
var ang
var lastlook
var shootRdy:bool
var Whereismousy
var lastMouse
var HealthPotionHeal = 50
var toggle = 0

func pos_to_chunk(x, y):
	var tile_x = floor(x / tile_size)
	var tile_y = floor(y / tile_size)
	var chunk_x = floor(tile_x / chunk_size)
	var chunk_y = floor(tile_y / chunk_size)
	return Vector2(chunk_x, chunk_y)

func _ready():
	max_harvesters = 5
	current_harverters = max_harvesters
	Healthpacks = 3
	consum = [4,5,6]
	toggleConsum.emit(toggle)
	hpPackCount.emit(Healthpacks)
	consumCount.emit(consum)
	DMG = 5 #+ tech tree bonus
	colable = [0,0,0,0,0,0] #These are the collectable startup values
	resourceA = 0
	looking = Vector2(1,0)
	lastlook = Vector2(1,0)
	lastMouse = Vector2(1,0)
	shootRdy = true
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
	
	
	#Where are we looking?
	Whereismousy = get_global_mouse_position()
	if Whereismousy != lastMouse:
		looking = (Whereismousy-global_position).normalized()
		lastMouse = Whereismousy
	#where is the player looking?
	if Input.get_vector("look_left","look_right","look_up","look_down") != Vector2.ZERO:
		looking = Input.get_vector("look_left","look_right","look_up","look_down")
	if looking != Vector2.ZERO:
		rotation = looking.angle()
		lastlook = looking# .normalized()
	
	#logic for shooting
	if Input.is_action_pressed("shoot") && shootRdy == true:
		var new_bullet = playerBullet.instantiate()
		new_bullet.damage = DMG
		new_bullet.position = $Marker2D.global_position
		new_bullet.direction = lastlook.normalized()
		add_sibling(new_bullet)
		shootRdy = false
		$ShootTimer.start()
	
	#Use the selected Consumable
	if Input.is_action_just_pressed("Use_consumable"):
		if consum[toggle] != 0:
			consum[toggle] += -1
			consumCount.emit(consum)
			for i in consum.size():
				#print("i=",i)
				if toggle == i: #If 0 use DamageBoost if 1 use StamBoost
					print("I want to use: ",i)
					break

	#cycle between the available consumables
	if Input.is_action_just_pressed("Toggle_consumables"):
		if toggle == consum.size()-1:
			toggle = 0
		else:
			toggle += 1
		toggleConsum.emit(toggle)
		print("Toggle:",toggle)
	
	#drink that health potion! (Or whatever it's called)
	if Input.is_action_just_pressed("Consume_HealthP"):
		if Healthpacks != 0 && currentHealth < maxHealth:
			Healthpacks += -1
			if currentHealth <= maxHealth-HealthPotionHeal:
				currentHealth += HealthPotionHeal
			else:
				currentHealth = maxHealth
			health_changed.emit(currentHealth,maxHealth)
			hpPackCount.emit(Healthpacks)
	
	if Input.is_action_just_pressed("harvest_test") && current_harverters != 0:
		current_harverters += -1
		print("spawning harvester")
		#Save.load_file(0)
		#var val = Save.get_value(0, "me", 0)
		#Save.set_value(0, "you", 1.4)
		#Save.set_value(0, "dog", "bailey" + str(val))
		#print(val)
		#Save.set_value(0, "me", val + 1)
		#Save.save_file(0)
		var harvester = harvester_scene.instantiate()
		harvester.position = position
		harvester.player = self
		harvester.ship = ship_scn
		harvester.search_dest = position + (lastlook.normalized() * harvester_throw_distance)
		main_scn.add_child(harvester)
	
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

	#create animation for standing still
	#$AnimatedSprite2D.animation = "standing"
	#$AnimatedSprite2D.play()
	
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

func _on_dash_wait_timeout() -> void:
	dashRdy =true

func _on_shoot_timer_timeout() -> void:
	shootRdy = true
	$ShootTimer.stop()

func _on_area_2d_area_entered(area: Area2D) -> void:
	currentHealth += -area.damage
	health_changed.emit(currentHealth,maxHealth)
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE

func _on_area_2d_collectable_area_entered(area: Area2D) -> void:
	for i in colnames.size():
		if area.name.left(3) == colnames[i]:
			colable[i] += 1
			gathered.emit(area.name.left(3))
			area.hide()
			area.queue_free()
			break
