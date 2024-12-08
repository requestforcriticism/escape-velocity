extends Node2D

signal ending_day

@export var playerBullet : PackedScene
@export var collectable : PackedScene

@export var tile_size = 32
@export var chunk_size = 32
@export var render_distance = 1
@export var dayLength =5*60 	# In seconds
@export var dayTimeLeft:int

var default_cursor = preload("res://assets/cursors/target_round_b.png")
var mining_cursor = preload("res://assets/cursors/tool_pickaxe.png")
var interectinfo

var daystarcolables: Array =[0,0,0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(default_cursor,Input.CURSOR_ARROW,Vector2(32,32))
	
	dayTimeLeft = dayLength
	$player/Camera2D.make_current()
	$player/Camera2D/PauseCanvasLayer/PauseMenu.visible = false
	$player.chunk_size = chunk_size
	$player.tile_size = chunk_size
	$grass_level/OutdoorLayer.chunk_size = chunk_size
	$grass_level/OutdoorLayer.tile_size = chunk_size
	$grass_level/OutdoorLayer.render_distance = render_distance
	start_day()
	
	var new_collectable = collectable.instantiate()
	new_collectable.type = "OIL"
	new_collectable.position = Vector2(100,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "WAT"
	new_collectable.position = Vector2(-100,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "URA"
	new_collectable.position = Vector2(50,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "IRO"
	new_collectable.position = Vector2(0,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "FOO"
	new_collectable.position = Vector2(-50,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "COM"
	new_collectable.position = Vector2(-150,100)
	add_child(new_collectable)
	
	new_collectable = collectable.instantiate()
	new_collectable.type = "OIL"
	new_collectable.position = Vector2(100,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "WAT"
	new_collectable.position = Vector2(-100,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "URA"
	new_collectable.position = Vector2(50,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "IRO"
	new_collectable.position = Vector2(0,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "FOO"
	new_collectable.position = Vector2(-50,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "COM"
	new_collectable.position = Vector2(-150,50)
	add_child(new_collectable)
	
	daystarcolables[0] = Save.get_value(1, "FOO", 0)
	daystarcolables[1] = Save.get_value(1, "WAT", 0)
	daystarcolables[2] = Save.get_value(1, "OIL", 0)
	daystarcolables[3] = Save.get_value(1, "IRO", 0)
	daystarcolables[4] = Save.get_value(1, "URA", 0)
	daystarcolables[5] = Save.get_value(1, "COM", 0)

	if Save.get_value(1, "Tutor", 1):
		$player/Camera2D/TutorialCanvasLayer.visible = true
	
#all the stuff to start a new day
func start_day():
	$player/Camera2D/hud.start_day(dayLength)
	$DayTimer.start()

func _process(delta):
	pass
	#if !get_tree().paused:
	#	Input.set_custom_mouse_cursor(default_cursor,Input.CURSOR_ARROW,Vector2(32,32))

func _physics_process(delta):
	var pp = PhysicsPointQueryParameters2D.new()
	pp.collide_with_areas = true  
	pp.position = get_global_mouse_position()
	
	if get_world_2d().direct_space_state.intersect_point(pp, 1):
		interectinfo = get_world_2d().direct_space_state.intersect_point(pp, 1)
		if str(interectinfo[0]["collider"]).left(8) == "resource":
			Input.set_custom_mouse_cursor(mining_cursor,Input.CURSOR_ARROW,Vector2(32,32))
		else:
			Input.set_custom_mouse_cursor(default_cursor,Input.CURSOR_ARROW,Vector2(32,32))
	else:
		Input.set_custom_mouse_cursor(default_cursor,Input.CURSOR_ARROW,Vector2(32,32))

func _on_day_timer_timeout() -> void:
	dayTimeLeft += -1
	if dayTimeLeft == 0:
		$DayTimer.stop()
		end_day()
		
func end_day():
	ending_day.emit()
	#await get_tree().create_timer(0.5).timeout
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for i in $player.colable.size():
		$player.colable[i] = 0
	
	
	$player/Camera2D/hud.visible = false
	for i in 100:
		$".".modulate.r += -.01
		$".".modulate.b += -.01
		$".".modulate.g += -.01
		await get_tree().create_timer(0.01).timeout
	
	var Mooo = 100+15
	get_tree().paused = false
	
	$player.position = $Ship.position + Vector2(0,Mooo)
	var CamZoom = $player/Camera2D.zoom
	$player/Camera2D.zoom = CamZoom * 1.3
	for i in 100:
		$".".modulate.r += .01
		$".".modulate.b += .01
		$".".modulate.g += .01
		await get_tree().create_timer(0.01).timeout
	
	CamZoom = $player/Camera2D.zoom
	for i in 100:
		$".".modulate.r += .02
		$".".modulate.b += .02
		$".".modulate.g += .02
		CamZoom = CamZoom*1.015#Vector2(1,1)
		Mooo += -1
		$player.position = $Ship.position + Vector2(0,Mooo)
		$player/Camera2D.zoom = CamZoom
		$Ship.modulate.r += .04
		$Ship.modulate.b += .04
		$Ship.modulate.g += .04
		
		await get_tree().create_timer(0.01).timeout
	Save.set_value(1, "HLTHPCK", $player.Healthpacks)
	Save.set_value(1, "STABST", $player.consum[0])
	Save.set_value(1, "DMGBST", $player.consum[1])
	Save.set_value(1, "DMGRED", $player.consum[2])
	
	Save.set_value(1, "COLLECTEDFOO", Save.get_value(1, "COLLECTEDFOO", 0) + Save.get_value(1, "FOO", 0) - daystarcolables[0]) #number of food collected during the game
	Save.set_value(1, "COLLECTEDWAT", Save.get_value(1, "COLLECTEDWAT", 0)+ Save.get_value(1, "WAT", 0) - daystarcolables[1]) #number of water collected during the game
	Save.set_value(1, "COLLECTEDOIL", Save.get_value(1, "COLLECTEDOIL", 0)+ Save.get_value(1, "OIL", 0) - daystarcolables[2]) #number of oil collected during the game
	Save.set_value(1, "COLLECTEDIRO", Save.get_value(1, "COLLECTEDIRO", 0)+ Save.get_value(1, "IRO", 0) - daystarcolables[3]) #number of iron collected during the game
	Save.set_value(1, "COLLECTEDURA", Save.get_value(1, "COLLECTEDURA", 0)+ Save.get_value(1, "URA", 0) - daystarcolables[4]) #number of uranium collected during the game
	Save.set_value(1, "COLLECTEDCOM", Save.get_value(1, "COLLECTEDCOM", 0)+ Save.get_value(1, "COM", 0) - daystarcolables[5]) #number of computer chips collected during the game
	
	#Save._save_file_win()  #save the game at the end of the day
	Save.set_value(1, "Phase", 1)
	Save.save_file(1)
	LevelManager.load_night()
	
func _on_pause_menu_ending_the_day() -> void:
	end_day()

func _on_player_health_changed(health,maxhealth) -> void:
	if health <= 0:
		end_day()
