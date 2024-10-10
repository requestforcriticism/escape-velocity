extends Control

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if visible == true:
		$MainWindow/WaterCollectable.play()
		$MainWindow/OilCollectable.play()
		$MainWindow/IronCollectable.play()
		$MainWindow/UraniumCollectable.play()
	pass

var _is_paused:bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible = _is_paused

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_day_phase"):
		_is_paused = !_is_paused
		print($"../../..".colable)
		
		#["BLU","IRO","OIL","WAT","URA"]
		$MainWindow/WaterPlayerAmount.text = str($"../../..".colable[3])
		$MainWindow/OilPlayerAmount.text = str($"../../..".colable[2])
		$MainWindow/IronPlayerAmount.text = str($"../../..".colable[1])
		$MainWindow/UraniumPlayerAmount.text = str($"../../..".colable[4])
		
		$MainWindow/WaterShipAmount.text = str(Save.get_value(1, "WAT", 0))
		$MainWindow/OilShipAmount.text = str(Save.get_value(1, "OIL", 0))
		$MainWindow/IronShipAmount.text = str(Save.get_value(1, "IRO", 0))
		$MainWindow/UraniumShipAmount.text = str(Save.get_value(1, "URA", 0))
		#print(Save.get_value(1, item, 0))


func _on_resume_button_pressed() -> void:
	_is_paused = false

func _on_end_day_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()


func _on_player_consum_count() -> void:
	pass # Replace with function body.


#func _on_player_gathered(cons) -> void:
	#print(cons)
	#pass # Replace with function body.
