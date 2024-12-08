extends Button


func _on_pressed() -> void:
	$"../../../Sounds/buttonpressed".play()
	release_focus()
	LevelManager.load_start()


func _on_mouse_entered() -> void:
	$"../../../Sounds/buttonhovered".play()
