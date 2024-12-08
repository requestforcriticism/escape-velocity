extends Button


func _on_pressed() -> void:
	$"../../../Sounds/buttonpressed".play()


func _on_mouse_entered() -> void:
	$"../../../Sounds/buttonhovered".play()
