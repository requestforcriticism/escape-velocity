extends CharacterBody2D

@export_group("External Scenes")
@export var playerBullet : PackedScene
@export var playerBulletMissile : PackedScene
@export var playerBulletSpray : PackedScene
@export var harvester_scene : PackedScene
@export var main_scn : Node
@export var ship_scn : Node
@export var reeb_scn : PackedScene
@export var fungal_scn : PackedScene
@export var tree_scn : PackedScene

signal on_chunk_changed
signal stamina_changed
signal health_changed
signal gathered
signal hpPackCount
signal consumCount
signal consDuration
signal toggleConsum
signal on_harvester_count_changed
signal on_harvester_max_changed
signal notenoughsta
signal usingweapon

@export_group("Procgen Properties")
@export var tile_size = 32
@export var chunk_size = 32

@export_group("Player Stats")
@export var BasemaxHealth = 100		#Max health
@export var BasehealthRegen = 0		#Amount of health regenerated each second. #A techtree upgrade may improve this.
@export var basespeed = 200			#Move speed
@export var BasemaxStamina = 100	#Max Stamina
@export var dashStaminaCost = 25	#Cost to Dash
@export var StaBaseWait = 1 		#time in seconds for the regen timer to start regenerateing after using STA.
@export var StaRegen = 1 			#Amount of stamina regen per .05 sec tick.
@export var Damage = 5				#Base damage from base weapon
@export var ShootSpeed = .2			#Bullets shoot at this rate in seconds.
@export var DamageRedBase = 0		#Reduce damage taken by static amount.
@export var missileStacost = 10		#Stamina cost to fire a missile.
@export var sprayStacost = 1		#Stamina cost to fire 1 bullet using the spray gun.
var PS = load("res://entities/player/player_stats.gd")
var PlayerStats

@export_group("consumables")
@export var Healthpacks:int #healthPack amounts
@export var consum = [0,0,0]  #consumable amounts [ stamina recovery, damage boost, damage reduction]
@export var consDur = [0.0,0.0,0.0]
var consDurRate = 15
var ConsumActive = [false,false,false]

@export var availible_harvesters:int
@export var max_harvesters:int = Save.get_value(1, "HARV", 1)

@export var DMG:float

enum PLAYER_WEAPONS { BASE, MISSILE, SPRAY}
var weapon_state

#type of collectables [blue,red,green,yellow,orange,purple]
@export var colable = [0,0,0,0,0,0,0,0]
@export var colnames = ["BLU","IRO","OIL","WAT","URA", "FOO", "COM"]

@export var run = 1
@export var harvester_throw_distance = 200

@export var player_tag = true



var running = 0
var dashDistance = 600
var dashing:int
var dashRdy:bool
var current_chunk = null
var looking
var ang
var lastlook
var BaseBulletshootRdy:bool
var MissileBulletshootRdy:bool
var SprayBulletshootRdy:bool
var Whereismousy
var lastMouse
var HealthPotionHeal = 50
var toggle = 0
var EndingDay:bool
var Move_state
var Action_State
var is_mining = false
var is_harverter = false
var bulletAlternate:bool = true
var distancetraveled
var walking:bool
var walksoundrdy:bool
var dayLength:float
var dayTimeLeft:float

func pos_to_chunk(x, y):
	var tile_x = floor(x / tile_size)
	var tile_y = floor(y / tile_size)
	var chunk_x = floor(tile_x / chunk_size)
	var chunk_y = floor(tile_y / chunk_size)
	return Vector2(chunk_x, chunk_y)

func _ready():
	walking = false
	walksoundrdy = true
	distancetraveled = 0
	weapon_state = PLAYER_WEAPONS.BASE
	usingweapon.emit(weapon_state)
	Move_state = "IDLE"
	Action_State = "PASSIVE"
	EndingDay = false
	PlayerStats = PS.new()
	PlayerStats.set_MaxHP(BasemaxHealth)
	PlayerStats.set_HealthRegen(BasehealthRegen)
	PlayerStats.set_MaxSTA(BasemaxStamina)
	PlayerStats.set_speed(basespeed)
	PlayerStats.set_StaInitialWait(StaBaseWait)
	PlayerStats.set_StaRegen(StaRegen)
	PlayerStats.set_DMG(Damage)
	PlayerStats.set_shootSpeed(ShootSpeed)
	PlayerStats.set_DMGReduction(DamageRedBase)
	$BaseBulletShootTimer.wait_time = PlayerStats.get_shootSpeed()
	$MissileBulletShootTimer.wait_time = 5*PlayerStats.get_shootSpeed()
	$SprayBulletShootTimer.wait_time = .25*PlayerStats.get_shootSpeed()
	availible_harvesters = max_harvesters
	Healthpacks = Save.get_value(1, "HLTHPCK", 0)
	consum = [Save.get_value(1, "STABST", 0),Save.get_value(1, "DMGBST", 0),Save.get_value(1, "DMGRED", 0)]  #set the starting number of consumables
	toggleConsum.emit(toggle)
	hpPackCount.emit(Healthpacks)
	consumCount.emit(consum)
	DMG = 5 #+ tech tree bonus
	colable = [0,0,0,0,0,0,0] #These are the collectable startup values
	$Camera2D/PauseCanvasLayer/PauseMenu.colable = colable
	looking = Vector2(1,0)
	lastlook = Vector2(1,0)
	lastMouse = Vector2(1,0)
	BaseBulletshootRdy = true
	MissileBulletshootRdy = true
	SprayBulletshootRdy = true
	$AnimatedSprite2D.animation = "walking"
	dashRdy =true
	stamina_changed.emit(PlayerStats.get_currentSTA(),PlayerStats.get_MaxSTA())
	health_changed.emit(PlayerStats.get_currentHP(),PlayerStats.get_MaxHP())
	$StaminaRegen.start()
	$HealthRegen.start()
	current_chunk = pos_to_chunk(position.x, position.y)
	on_chunk_changed.emit(current_chunk)
	on_harvester_count_changed.emit(availible_harvesters)
	on_harvester_max_changed.emit(max_harvesters)

func _process(delta: float) -> void:
	var startpos = global_position
	Move_state = "IDLE"
	Action_State = "PASSIVE"
	velocity = Vector2.ZERO
	
	if EndingDay == true:
		Move_state = "WALKING"
		#$AnimatedSprite2D.animation = "walking"
		#$AnimatedSprite2D.play("walking")

	
	
	velocity = Input.get_vector("move_left","move_right","move_up","move_down").normalized()

	if velocity.length() > 0:
		move_and_collide(velocity)
		velocity = velocity * PlayerStats.get_speed()
		if dashing == 0:
			Move_state = "WALKING"
			walking = true
			$walkingsoundTimer.wait_time = .4
			#$AnimatedSprite2D.animation = "walking"
			#$AnimatedSprite2D.play()
	else:
		walking = false
	
	if Input.is_action_pressed("running"):
		if PlayerStats.get_currentSTA() > 0:
			running = 1
			_using_stamina(-1)
			$walkingsoundTimer.wait_time = .2
		else:
			notenoughsta.emit()
	
	#elif velocity.length() == 0  && dashing == 0 && EndingDay == false:
		#$AnimatedSprite2D.stop()
	
	if running >0:
		position += (velocity + velocity*running*run) * delta
		running += -.05			#if running slow down
	else:
		position += (velocity) * delta
		running = 0
	
	#Where are we looking?
	Whereismousy = get_global_mouse_position()
	if Whereismousy != lastMouse:
		looking = (Whereismousy-global_position).normalized()
		lastMouse = Whereismousy
	#where is the player looking?
	if Input.get_vector("look_left","look_right","look_up","look_down") != Vector2.ZERO:
		looking = Input.get_vector("look_left","look_right","look_up","look_down")
	if looking != Vector2.ZERO && EndingDay == false:
		rotation = looking.angle()
		lastlook = looking# .normalized()
	
	#logic for shooting
	if Input.is_action_pressed("shoot") && EndingDay == false:
		if consDur[1] > 0:
				Action_State = "DOUBLE_SHOOTING"
		else:
			Action_State = "SHOOTING"
		
		if weapon_state == PLAYER_WEAPONS.MISSILE:
			_missile_bullet()
		elif weapon_state == PLAYER_WEAPONS.SPRAY:
			_spray_bullet()
		else:
			_base_bullet()
	
	#drink that health potion! (Or whatever it's called)
	if Input.is_action_just_pressed("Consume_HealthP") && Healthpacks != 0 && PlayerStats.get_currentHP() < PlayerStats.get_MaxHP():
		Healthpacks += -1
		PlayerStats.set_currentHP(HealthPotionHeal)
		health_changed.emit(PlayerStats.get_currentHP(),PlayerStats.get_MaxHP())
		hpPackCount.emit(Healthpacks)
	
	if Input.is_action_just_pressed("harvest_test") && availible_harvesters > 0:
		$harvesterTimer.start()
		is_harverter = true
		availible_harvesters += -1
		on_harvester_count_changed.emit(availible_harvesters)
		var harvester = harvester_scene.instantiate()
		#harvester.position = position
		harvester.position = $Marker2Dright.global_position
		harvester.player = self
		harvester.ship = ship_scn
		harvester.search_dest = position + (lastlook.normalized() * harvester_throw_distance)
		harvester.connect("returned", harvester_return)
		main_scn.add_child(harvester)
	
	#logic for dashing
	if dashRdy == true && Input.is_action_just_pressed("dash") && EndingDay == false:
		if PlayerStats.get_currentSTA() > dashStaminaCost:
			dashing = 10
			$Area2D/DamageCollisionShape2D.disabled = true
			_using_stamina(-dashStaminaCost)
			dashRdy = false
			$DashWait.start()
			$AnimatedSprite2DFire.play("dash")
			$AnimatedSprite2DFire.visible = true
		else:
			notenoughsta.emit()
		
	if dashing > 0:
		dashing += -1
		position += velocity.normalized()*dashDistance*delta
		$AnimatedSprite2DFire.play("dash")
		if dashing == 0:
			$AnimatedSprite2DFire.pause()
			$AnimatedSprite2DFire.visible = false
			$Area2D/DamageCollisionShape2D.disabled = false

	var chunk_id = pos_to_chunk(position.x, position.y)
	
	if current_chunk.x != chunk_id.x || current_chunk.y != chunk_id.y:
		current_chunk = chunk_id
		on_chunk_changed.emit(current_chunk)
	
	distancetraveled += global_position.distance_to(startpos)
	
	if is_mining == true:
		Action_State = "MINING"
	if is_harverter == true:
		Action_State = "HARVESTER"
	$AnimatedSprite2D.change_state(Move_state,Action_State)
	
	if walking && walksoundrdy:
		$sounds/walking.play()
		$walkingsoundTimer.start()
		walksoundrdy=false
	

func _using_stamina(Stacost):
	$StaminaRegen.stop()
	PlayerStats.set_currentSTA(Stacost)
	stamina_changed.emit(PlayerStats.get_currentSTA(),PlayerStats.get_MaxSTA())
	$StaminaRegen.wait_time = PlayerStats.get_StaInitialWait()
	$StaminaRegen.start()
	$StaminaRegen.wait_time = .05

func _input(event):
	if event.is_action_pressed("pressed_one"):
		weapon_state = PLAYER_WEAPONS.BASE
		usingweapon.emit(weapon_state)
	if event.is_action_pressed("pressed_two") && Save.get_value(1, str("MissileWeapon"), 0) == 2:
		weapon_state = PLAYER_WEAPONS.MISSILE
		usingweapon.emit(weapon_state)
	if event.is_action_pressed("pressed_three") && Save.get_value(1, str("SprayWeapon"), 0) == 2:
		weapon_state = PLAYER_WEAPONS.SPRAY
		usingweapon.emit(weapon_state)

func _base_bullet():
	if BaseBulletshootRdy == true:
			var new_bullet = playerBullet.instantiate()
			new_bullet.rotation = lastlook.angle()
			new_bullet.damage = PlayerStats.get_DMG()
			if consDur[1] > 0:
				if bulletAlternate == true:
					new_bullet.position = $Marker2Dright.global_position
					bulletAlternate = false
				else:
					new_bullet.position = $Marker2Dleft.global_position
					bulletAlternate = true
			else:
				new_bullet.position = $Marker2Dright.global_position
			new_bullet.direction = lastlook.normalized()
			add_sibling(new_bullet)
			Save.set_value(1, "BASESHOTS", Save.get_value(1, "BASESHOTS", 0)+1)
			BaseBulletshootRdy = false
			$sounds/basebullet.play()
			$BaseBulletShootTimer.start()

func _missile_bullet():
	if MissileBulletshootRdy == true:
		if PlayerStats.get_currentSTA() >= missileStacost:
			_using_stamina(-missileStacost)
			var new_bullet = playerBulletMissile.instantiate()
			new_bullet.rotation = lastlook.angle()
			new_bullet.damage = 0
			new_bullet.explosiondamage = 5 * PlayerStats.get_DMG()
			if consDur[1] > 0:
				if bulletAlternate == true:
					new_bullet.position = $Marker2Dright.global_position
					bulletAlternate = false
				else:
					new_bullet.position = $Marker2Dleft.global_position
					bulletAlternate = true
			else:
				new_bullet.position = $Marker2Dright.global_position
			new_bullet.direction = lastlook.normalized()
			Save.set_value(1, "MISSILESHOTS", Save.get_value(1, "MISSILESHOTS", 0)+1)
			add_sibling(new_bullet)
			MissileBulletshootRdy = false
			$sounds/missilebullet.play()
			$MissileBulletShootTimer.start()
		else:
			notenoughsta.emit()

func _spray_bullet():
	if SprayBulletshootRdy == true:
		if PlayerStats.get_currentSTA() >= sprayStacost:
			_using_stamina(-sprayStacost)
			var new_bullet_Spray = playerBulletSpray.instantiate()
			var mod_bullet = randf_range(-PI / 32, PI / 32)
			new_bullet_Spray.rotation = lastlook.angle() + mod_bullet
			new_bullet_Spray.damage = .8 * PlayerStats.get_DMG()
			if consDur[1] > 0:
				if bulletAlternate == true:
					new_bullet_Spray.position = $Marker2Dright.global_position
					bulletAlternate = false
				else:
					new_bullet_Spray.position = $Marker2Dleft.global_position
					bulletAlternate = true
			else:
				new_bullet_Spray.position = $Marker2Dright.global_position
			new_bullet_Spray.direction = Vector2.from_angle(lastlook.angle() + mod_bullet).normalized()
			Save.set_value(1, "SPRAYSHOTS", Save.get_value(1, "SPRAYSHOTS", 0)+1)
			add_sibling(new_bullet_Spray)
			SprayBulletshootRdy = false
			$sounds/spraybullet.play()
			$SprayBulletShootTimer.start()
		else:
			notenoughsta.emit()

func harvester_return():
	availible_harvesters += 1
	on_harvester_count_changed.emit(availible_harvesters)

func _on_stamina_regen_timeout() -> void:
	PlayerStats.set_currentSTA(PlayerStats.get_StaRegen())
	stamina_changed.emit(PlayerStats.get_currentSTA(),PlayerStats.get_MaxSTA())

func _on_health_regen_timeout() -> void:
	PlayerStats.Regen_HP()
	health_changed.emit(PlayerStats.get_currentHP(),PlayerStats.get_MaxHP())

func _on_dash_wait_timeout() -> void:
	dashRdy =true

func _on_shoot_timer_timeout() -> void:
	BaseBulletshootRdy = true
	$BaseBulletShootTimer.wait_time = PlayerStats.get_shootSpeed()

func _on_missile_bullet_shoot_timer_timeout() -> void:
	MissileBulletshootRdy = true
	$MissileBulletShootTimer.wait_time = 5*PlayerStats.get_shootSpeed()

func _on_spray_bullet_shoot_timer_timeout() -> void:
	SprayBulletshootRdy = true
	$SprayBulletShootTimer.wait_time = .5*PlayerStats.get_shootSpeed()

func damage_player(dmg):
	PlayerStats.set_currentHP(-dmg + PlayerStats.get_DMGReduction())
	health_changed.emit(PlayerStats.get_currentHP(),PlayerStats.get_MaxHP())
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if "damage" in area:
		PlayerStats.set_currentHP(-area.damage + PlayerStats.get_DMGReduction())
		health_changed.emit(PlayerStats.get_currentHP(),PlayerStats.get_MaxHP())
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color.WHITE

#	colnames = ["BLU","IRO","OIL","WAT","URA", "FOO", "COM"]
func _on_area_2d_collectable_area_entered(area: Area2D) -> void:
	for i in colnames.size():
		if area.name.left(3) == colnames[i]:
			colable[i] += 1
			$Camera2D/PauseCanvasLayer/PauseMenu.colable[i] = colable[i] 
			gathered.emit(area.name.left(3))
			area.hide()
			area.queue_free()
			break

func Use_cons():
	if consum[toggle] != 0:
			consum[toggle] += -1
			consumCount.emit(consum)
			consDur[toggle] += consDurRate
			using_consumable(toggle,true)
	if $ConsumableTimer.is_stopped() == true:
		$ConsumableTimer.start()

func _on_consumable_timer_timeout() -> void:
	if consDur.max() == 0:
		$ConsumableTimer.stop()
	for i in consDur.size():
		if consDur[i] > 0:
			consDur[i] = snapped(consDur[i] - .1, .1)
			consDuration.emit(consDur)
		else:
			consDur[i] = 0.0
			using_consumable(i,false)

#consumable amounts [ stamina recovery, damage boost, damage reduction]
func using_consumable(tog:int, using:bool):
	if tog == 0: #Stamina recovery
		if using == true && ConsumActive[tog] == false:
			PlayerStats.set_StaInitialWait(StaBaseWait * 0.5)
			PlayerStats.set_StaRegen(StaRegen * 2)
			ConsumActive[tog] = true
		elif using == false:
			PlayerStats.set_StaInitialWait(StaBaseWait)
			PlayerStats.set_StaRegen(StaRegen)
			ConsumActive[tog] = false
	if tog == 1: #Damage Boost
		if using == true && ConsumActive[tog] == false:
			PlayerStats.set_DMG(Damage * 1.5)
			PlayerStats.set_shootSpeed(ShootSpeed * 0.5)
			ConsumActive[tog] = true
		elif using == false:
			PlayerStats.set_DMG(Damage)
			PlayerStats.set_shootSpeed(ShootSpeed)
			ConsumActive[tog] = false
	if tog == 2: #Damage Reduction & small Health Regeneration
		if using == true && ConsumActive[tog] == false:
			PlayerStats.set_DMGReduction(DamageRedBase + 2)
			PlayerStats.set_HealthRegen(BasehealthRegen + 1)
			ConsumActive[tog] = true
		elif using == false:
			PlayerStats.set_DMGReduction(DamageRedBase)
			PlayerStats.set_HealthRegen(BasehealthRegen)
			ConsumActive[tog] = false

func _on_day_phase_ending_day() -> void:
	EndingDay = true
	rotation = -PI/2
	Save.set_value(1, "DISTRAVEL", Save.get_value(1, "DISTRAVEL", 0) + distancetraveled)  
	

func _on_base_resource_getting_gathered(message) -> void:
	is_mining = true
	$miningTimer.start()

func _link_resource(Res):
	Res.connect("getting_gathered",_on_base_resource_getting_gathered)


func _on_mining_timer_timeout() -> void:
	is_mining = false


func _on_harvester_timer_timeout() -> void:
	is_harverter = false

func _on_pause_menu_using_stabst() -> void:
	using_consumable(0, true)
	_check_cons_timer()
	consDur[0] += consDurRate
	consDuration.emit(consDur)

func _on_pause_menu_using_dmgbst() -> void:
	using_consumable(1, true)
	_check_cons_timer()
	consDur[1] += consDurRate
	consDuration.emit(consDur)

func _on_pause_menu_using_dmgred() -> void:
	using_consumable(2, true)
	_check_cons_timer()
	consDur[2] += consDurRate
	consDuration.emit(consDur)
	
func _check_cons_timer():
	if $ConsumableTimer.is_stopped() == true:
		$ConsumableTimer.start()
	
func _on_walkingsound_timer_timeout() -> void:
	walksoundrdy = true

func _on_monster_spawn_timer_timeout():
	var spawn_radius = 500
	var roll = randi_range(1, 10)
	var x_offset = randi_range(-spawn_radius, spawn_radius)
	var y_offset = randi_range(-spawn_radius, spawn_radius)
	var spawn_pos = Vector2i(global_position.x + x_offset, global_position.y + y_offset)
	var new_mon
	
	if roll <= 5:
		new_mon = reeb_scn.instantiate()
	elif roll <= 10:
		new_mon = fungal_scn.instantiate()
	else:
		new_mon = tree_scn.instantiate()
		
	var timeratio = dayLength/dayTimeLeft
	#print(timeratio)
	
	
	new_mon.damage = 3 + min(floori(timeratio),7)
	new_mon.max_hp = 15 + min(floori(10*timeratio),85)
	new_mon.global_position = spawn_pos
	new_mon.timeratio = timeratio
	add_sibling(new_mon)
	
	$MonsterSpawnTimer.wait_time = 10.0 - min(timeratio*9.5/15,9.5)
	#print("timeratio: ",timeratio)
	#print($MonsterSpawnTimer.wait_time)

func _on_day_phase_day_lengthsig(DayLength) -> void:
	dayLength = DayLength
	
func _on_day_phase_day_time_leftsig(DayTimeLeft) -> void:
	dayTimeLeft = DayTimeLeft
