extends Control

var New_game_scene:bool
var i:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	New_game_scene = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if New_game_scene:
		if Input.is_action_pressed("skip_scene"):
			_start_new_game()
		if i == 0:
			$GridContainer/NewGameButton.disabled = true
			$GridContainer/LoadGame.disabled = true
			$GridContainer/QuitButton.disabled = true
			for i in 40:
				$escapekey.modulate.a += .005
				$TitleName.modulate.a += -.005
				$GridContainer.modulate.a += -.005
				await get_tree().create_timer(0.02).timeout
		#$player.position = $Ship.position + Vector2(0,Mooo)
			$Ship.visible = true
		if i<1000:
			$Ship/AnimatedSprite2D.play("working")
		
			$Ship.position += Vector2(1,0)
		#print($Ship.global_position)
			
		if i>=1000 && i<1520:
			if (i>1100 && i<1150) || (i>1300 && i<1330) || (i>1500 && i<1520):
				$Ship/AnimatedSprite2D.visible = true
				$Ship/AnimatedSprite2D.play("working")
				$Ship.position += Vector2(1,0)
			else:
				$Ship/AnimatedSprite2D.visible = false
				$Ship.position += Vector2(.5,0)
			
		if i>1050:
				$planet.visible = true
				$planet.position += Vector2(-.5,0)
		if i>=1520 && $Ship.scale > Vector2(0,0):
			$Ship/AnimatedSprite2D.visible = false
			$Ship.scale += -Vector2(.005,.005)
			$Ship.position += Vector2(1,0)
			
		$newgamemesage.visible_ratio = i/2000.0
		
		if i > 2300:
			$newgamemesage.modulate.a += -.01
			$planet.scale += Vector2(.01,.01)
			
		if i >2400:
			$".".modulate.r += -.01
			$".".modulate.b += -.01
			$".".modulate.g += -.01
			
		if i == 2600:
			_start_new_game()
			
		await get_tree().create_timer(0.01).timeout
		i += 1
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_new_game_button_pressed() -> void:
	New_game_scene = true

func _on_load_game_pressed() -> void:
	#Save._load_file_win(1)
	print("put some stuff for loading a previously played game")

func _start_new_game():
	Save.set_value(1, "WINLOSE", 0)
	Save.set_value(1, "SHIPREPAIR", 0)
	Save.set_value(1, "DAY", 1)
	Save.set_value(1, "FOO", 30)
	Save.set_value(1, "WAT", 30)
	Save.set_value(1, "OIL", 40)
	Save.set_value(1, "IRO", 40)
	Save.set_value(1, "URA", 40)
	Save.set_value(1, "COM", 40)
	Save.set_value(1, "HLTHPCK", 5)
	Save.set_value(1, "STABST", 6)
	Save.set_value(1, "DMGBST", 7)
	Save.set_value(1, "DMGRED", 8)
	Save.set_value(1, "HARV", 1)
	Save.set_value(1, "Tutor", 1)
	
	# For the end of game stats
	Save.set_value(1, "BASESHOTS", 0)  #number of total base shots fired
	Save.set_value(1, "MISSILESHOTS", 0)  #number of total missile shots fired
	Save.set_value(1, "SPRAYSHOTS", 0)  #number of total spray shots fired
	Save.set_value(1, "DAMAGET", 0) #amount of damage taken
	Save.set_value(1, "DISTRAVEL", 0.0) #distance traveled in pixels.  convert to some distance later.
	Save.set_value(1, "BRDEF", 0) #number of Base Resourses defeated
	Save.set_value(1, "MONDEF", 0) #number of monsters defeated
	Save.set_value(1, "COLLECTEDFOO", 0) #number of food collected during the game
	Save.set_value(1, "COLLECTEDWAT", 0) #number of water collected during the game
	Save.set_value(1, "COLLECTEDOIL", 0) #number of oil collected during the game
	Save.set_value(1, "COLLECTEDIRO", 0) #number of iron collected during the game
	Save.set_value(1, "COLLECTEDURA", 0) #number of uranium collected during the game
	Save.set_value(1, "COLLECTEDCOM", 0) #number of computer chips collected during the game
	
	Save.set_value(1, str("MissileWeapon"), 2)
	Save.set_value(1, str("SprayWeapon"), 2)
	
	
	release_focus()
	LevelManager.load_day()
	
