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
	Save.set_value(1, "DAY", 1)
	release_focus()
	LevelManager.load_day()


func _on_load_game_pressed() -> void:
	print("put some stuff for loading a previously played game")
