extends AudioStreamPlayer

func _process(delta):
	if get_tree().paused:
		$".".volume_db = -10
	else:
		$".".volume_db = -4

func _on_finished() -> void:
	$".".play()
