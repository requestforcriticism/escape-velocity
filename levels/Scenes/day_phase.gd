extends Node2D

signal ending_day

@export var playerBullet : PackedScene
@export var collectable : PackedScene

@export var tile_size = 32
@export var chunk_size = 32
@export var render_distance = 1
@export var dayLength = 10*60 	# In seconds
@export var dayTimeLeft:int

# Called when the node enters the scene tree for the first time.
func _ready():
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
	
#all the stuff to start a new day
func start_day():
	$player/Camera2D/hud.start_day(dayLength)
	$DayTimer.start()

func _process(delta):
	pass

func _on_day_timer_timeout() -> void:
	dayTimeLeft += -1
	if dayTimeLeft == 0:
		$DayTimer.stop()
		end_day()
		
func end_day():
	for i in $player.colable.size():
		$player.colable[i] = 0
	get_tree().paused = true
	$player/Camera2D/hud.visible = false
	for i in 100:
		$".".modulate.r += -.01
		$".".modulate.b += -.01
		$".".modulate.g += -.01
		await get_tree().create_timer(0.01).timeout
	ending_day.emit()
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
	
	#Save._save_file_win()  #save the game at the end of the day
	#Save._save_file_win(1)
	LevelManager.load_night()
	
func _on_pause_menu_ending_the_day() -> void:
	end_day()

func _on_player_health_changed(health,maxhealth) -> void:
	if health <= 0:
		end_day()
