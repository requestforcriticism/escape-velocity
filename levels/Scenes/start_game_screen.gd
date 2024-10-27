extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_new_game_button_pressed() -> void:
	Save.set_value(1, "SHIPREPAIR", 0)
	Save.set_value(1, "DAY", 1)
	Save.set_value(1, "FOO", 30)
	Save.set_value(1, "WAT", 30)
	Save.set_value(1, "OIL", 20)
	Save.set_value(1, "IRO", 20)
	Save.set_value(1, "URA", 20)
	Save.set_value(1, "COM", 20)
	Save.set_value(1, "HLTHPCK", 0)
	Save.set_value(1, "STABST", 0)
	Save.set_value(1, "DMGBST", 0)
	Save.set_value(1, "DMGRED", 0)
	Save.set_value(1, "HARV", 1)
	
	# For the end of game stats
	Save.set_value(1, "SHOTS", 0)  #number of total shots fired
	Save.set_value(1, "DAMAGET", 0) #amount of damage taken
	Save.set_value(1, "DISTRAVEL", 0) #distance traveled in pixels.  convert to some distance later.
	Save.set_value(1, "BRDEF", 0) #number of Base Resourses defeated
	Save.set_value(1, "MONDEF", 0) #number of monsters defeated
	
	release_focus()
	LevelManager.load_day()

func _on_load_game_pressed() -> void:
	print("put some stuff for loading a previously played game")
