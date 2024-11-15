extends Control

signal EndingTheDay

@export var buttons_active:bool = true

func _ready() -> void:
	$GridContainer.visible = buttons_active

func _process(delta: float) -> void:
	if visible == true:
		$MainWindow/FoodCollectable.play()
		$MainWindow/WaterCollectable.play()
		$MainWindow/OilCollectable.play()
		$MainWindow/IronCollectable.play()
		$MainWindow/UraniumCollectable.play()
		$MainWindow/CompChipCollectable.play()

var _is_paused:bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible = _is_paused
		if _is_paused == false:
			close_checkbox()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_day_phase"):
		_is_paused = !_is_paused
		
		#["BLU","IRO","OIL","WAT","URA", "FOO", "COM"]
		$MainWindow/FoodPlayerAmount.text = str($"../../..".colable[5])
		$MainWindow/WaterPlayerAmount.text = str($"../../..".colable[3])
		$MainWindow/OilPlayerAmount.text = str($"../../..".colable[2])
		$MainWindow/IronPlayerAmount.text = str($"../../..".colable[1])
		$MainWindow/UraniumPlayerAmount.text = str($"../../..".colable[4])
		$MainWindow/CompChipPlayerAmount.text = str($"../../..".colable[6])
		
		$MainWindow/FoodShipAmount.text = str(Save.get_value(1, "FOO", 0))
		$MainWindow/WaterShipAmount.text = str(Save.get_value(1, "WAT", 0))
		$MainWindow/OilShipAmount.text = str(Save.get_value(1, "OIL", 0))
		$MainWindow/IronShipAmount.text = str(Save.get_value(1, "IRO", 0))
		$MainWindow/UraniumShipAmount.text = str(Save.get_value(1, "URA", 0))
		$MainWindow/CompChipShipAmount.text = str(Save.get_value(1, "COM", 0))

func _on_resume_button_pressed() -> void:
	_is_paused = false

func _on_end_day_button_pressed() -> void:
	$CheckEndDay.visible = true
	$GridContainer/EndDayButton.disabled = true
	$GridContainer/ResumeButton.disabled = true
	$GridContainer/QuitGameButton.disabled = true
	$ColorRectMenuCheck.visible = true

func _on_quit_game_button_pressed() -> void:
	$CheckMainMenu.visible = true
	$GridContainer/EndDayButton.disabled = true
	$GridContainer/ResumeButton.disabled = true
	$GridContainer/QuitGameButton.disabled = true
	$ColorRectMenuCheck.visible = true

func _on_player_consum_count() -> void:
	pass # Replace with function body.

func _on_mm_yes_button_pressed() -> void:
	_is_paused = false
	release_focus()
	LevelManager.load_start()

func _on_mm_no_button_pressed() -> void:
	close_checkbox()

func _on_ed_yes_button_pressed() -> void:
	_is_paused = false
	EndingTheDay.emit()
	#release_focus()
	#LevelManager.load_night()

func _on_ed_no_button_pressed() -> void:
	close_checkbox()
	
func close_checkbox():
	$CheckEndDay.visible = false
	$CheckMainMenu.visible = false
	$GridContainer/EndDayButton.disabled = false
	$GridContainer/ResumeButton.disabled = false
	$GridContainer/QuitGameButton.disabled = false
	$ColorRectMenuCheck.visible = false
