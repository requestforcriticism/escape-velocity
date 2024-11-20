extends Control

var numberpages = 12
var pagenumber:int
var pause_menu_input_events
var inputdisabling:bool
var restartTut
var menu_cursor = preload("res://assets/cursors/pointer_b.png")

func _ready() -> void:
	await get_tree().create_timer(.5).timeout
	if Save.get_value(1, "Tutor", 1):
		_startup()
	else:
		visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("end_tutorial"):
		if $tutorialreminder.visible:
			restartTut = false
			get_tree().paused = false
			#$"..".visible = false
			$tutorialreminder.visible = false
			renable_pause_menu()
		elif visible:
			_UL_page(pagenumber)
			$Buttonnext.visible = false
			$Buttonprevious.visible = false
			$ButtonexitH2P.visible = false
			if Save.get_value(1, "Tutor", 1):
				Save.set_value(1, "Tutor", 0)
				$tutorialreminder.visible = true
				release_focus()
			else:
				get_tree().paused = false
				restartTut = false
				renable_pause_menu()
				visible = false
	if visible:
		print(delta,"still visible")
		Input.set_custom_mouse_cursor(menu_cursor,Input.CURSOR_ARROW,Vector2(20,16))
		pass

func _startup():
	restartTut = true
	pagenumber = 0
	_L_page(pagenumber)
	disable_pause_menu()
	$"..".visible = true
	$Buttonnext.visible = true
	$Buttonprevious.visible = true
	$ButtonexitH2P.visible = true
	get_tree().paused = true
	PhysicsServer2D.set_active(true)

func _on_buttonnext_pressed() -> void:
	_UL_page(pagenumber)
	pagenumber = (pagenumber+1)%numberpages
	_L_page(pagenumber)

func _on_buttonprevious_pressed() -> void:
	_UL_page(pagenumber)
	pagenumber = (pagenumber+numberpages-1)%numberpages
	_L_page(pagenumber)

func _on_buttonexit_h_2p_pressed() -> void:
	_UL_page(pagenumber)
	$Buttonnext.visible = false
	$Buttonprevious.visible = false
	$ButtonexitH2P.visible = false
	if Save.get_value(1, "Tutor", 1):
		Save.set_value(1, "Tutor", 0)
		$tutorialreminder.visible = true
		release_focus()
	else:
		get_tree().paused = false
		restartTut = false
		renable_pause_menu()
		visible = false

func _UL_page(PN):
	get_node(str("page",PN)).visible = false

func _L_page(PN):
	get_node(str("page",PN)).visible = true


func _on_buttonclosewindow_pressed() -> void:
	restartTut = false
	get_tree().paused = false
	visible = !visible
	$tutorialreminder.visible = false
	renable_pause_menu()
	visible = false
	
func disable_pause_menu():
	pause_menu_input_events = InputMap.action_get_events("pause_day_phase")
	InputMap.action_erase_events("pause_day_phase")

func renable_pause_menu():
	if pause_menu_input_events != null:
		for input_event in pause_menu_input_events:
			InputMap.action_add_event("pause_day_phase", input_event)

func _on_pause_menu_turnontutorial() -> void:
	visible = true
	_startup()
	#get_tree().paused = true
	#print("show me tutorial")
	#$Buttonnext.visible = true
	#$Buttonprevious.visible = true
	#$ButtonexitH2P.visible = true
	#pagenumber = 0
	#_L_page(pagenumber)
	#restartTut = true
	
