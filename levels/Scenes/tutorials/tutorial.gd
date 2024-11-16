extends Control

var numberpages = 10
var pagenumber:int
var pause_menu_input_events
var inputdisabling:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($"..".visible)
	pagenumber = 0
	await get_tree().create_timer(2).timeout
	if Save.get_value(1, "Tutor", 1):
		get_tree().paused = true
	PhysicsServer2D.set_active(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"..".visible == true && !inputdisabling:
		disable_pause_menu()
		inputdisabling = true

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
	
func _UL_page(PN):
	get_node(str("page",PN)).visible = false

func _L_page(PN):
	get_node(str("page",PN)).visible = true


func _on_buttonclosewindow_pressed() -> void:
	get_tree().paused = false
	$"..".visible = false
	$tutorialreminder.visible = false
	renable_pause_menu()
	
func disable_pause_menu():
	pause_menu_input_events = InputMap.action_get_events("pause_day_phase")
	InputMap.action_erase_events("pause_day_phase")
	print("disabling")
	
func renable_pause_menu():
	for input_event in pause_menu_input_events:
		InputMap.action_add_event("pause_day_phase", input_event)
		print("enabling")
