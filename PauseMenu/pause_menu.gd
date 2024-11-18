extends Control

signal using_STABST
signal using_DMGBST
signal using_DMGRED
signal consumCount
signal EndingTheDay
signal turnontutorial

var consum
var consDur
var ConsDurRate
var menu_cursor = preload("res://assets/cursors/pointer_b.png")

@export var buttons_active:bool = true

@export var colable = [0,0,0,0,0,0,0]

func _ready() -> void:
	consDur = [0,0,0]
	consum = [Save.get_value(1, "STABST", 0),Save.get_value(1, "DMGBST", 0),Save.get_value(1, "DMGRED", 0)]
	$Consumables/GridContainer/TBSTABST/amount.text = str(consum[0])
	$Consumables/GridContainer/TBDMGBST/amount.text = str(consum[1])
	$Consumables/GridContainer/TBDMGRED/amount.text = str(consum[2])
	$GridContainer.visible = buttons_active
	$Consumables/GridContainer/TBSTABST/duration.text = str(0," secs")
	$Consumables/GridContainer/TBDMGBST/duration.text = str(0," secs")
	$Consumables/GridContainer/TBDMGRED/duration.text = str(0," secs")

func _process(delta: float) -> void:
	if visible:
		$MainWindow/FoodCollectable.play()
		$MainWindow/WaterCollectable.play()
		$MainWindow/OilCollectable.play()
		$MainWindow/IronCollectable.play()
		$MainWindow/UraniumCollectable.play()
		$MainWindow/CompChipCollectable.play()
		Input.set_custom_mouse_cursor(menu_cursor,Input.CURSOR_ARROW,Vector2(20,16))

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
		$MainWindow/FoodPlayerAmount.text = str(colable[5])
		$MainWindow/WaterPlayerAmount.text = str(colable[3])
		$MainWindow/OilPlayerAmount.text = str(colable[2])
		$MainWindow/IronPlayerAmount.text = str(colable[1])
		$MainWindow/UraniumPlayerAmount.text = str(colable[4])
		$MainWindow/CompChipPlayerAmount.text = str(colable[6])
		
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

func _on_tbstabst_pressed() -> void:
	if consum[0] != 0:
		consum[0] += -1
		using_STABST.emit()
		Save.set_value(1, "STABST", consum[0])
		consumCount.emit(consum)
		$Consumables/GridContainer/TBSTABST/amount.text = str(consum[0])
		#$Consumables/TBSTABST/duration.text = str(consDur[0] + ConsDurRate," secs")

func _on_tbdmgbst_pressed() -> void:
	if consum[1] != 0:
		consum[1] += -1
		using_DMGBST.emit()
		Save.set_value(1, "DMGBST", consum[1])
		consumCount.emit(consum)
		$Consumables/GridContainer/TBDMGBST/amount.text = str(consum[1])
		#$Consumables/TBDMGBST/duration.text = str(consDur[1] + ConsDurRate," secs")

func _on_tbdmgred_pressed() -> void:
	if consum[2] != 0:
		consum[2] += -1
		using_DMGRED.emit()
		Save.set_value(1, "DMGRED", consum[2])
		consumCount.emit(consum)
		$Consumables/GridContainer/TBDMGRED/amount.text = str(consum[2])
		#$Consumables/TBDMGRED/duration.text = str(consDur[2] + ConsDurRate," secs")

func _on_player_cons_duration(CD) -> void:
	consDur = CD
	$Consumables/GridContainer/TBSTABST/duration.text = str(consDur[0]," secs")
	$Consumables/GridContainer/TBDMGBST/duration.text = str(consDur[1]," secs")
	$Consumables/GridContainer/TBDMGRED/duration.text = str(consDur[2]," secs")

func _on_how_to_play_button_pressed() -> void:
	_is_paused = !_is_paused
	
	turnontutorial.emit()
