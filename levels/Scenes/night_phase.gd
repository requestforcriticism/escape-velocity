extends Node2D

var starting:bool
var BG_landing_pos
var BG_craft_pos
var BG_tech_pos
var BG_fix_pos
var BG_landing_size
var BG_craft_size
var BG_tech_size
var BG_fix_size

enum PAGE_STATE {LANDING, CRAFTING, TECH, FIX}

var page_state

var menu_cursor = preload("res://assets/cursors/pointer_b.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PhysicsServer2D.set_active(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if get_tree().paused:
		get_tree().paused = false
	page_state = PAGE_STATE.LANDING 
	BG_landing_pos = $landingPageBG.position
	BG_craft_pos = $CraftingPage/CraftingPageBG.position
	BG_tech_pos = $TechTreePage/TechPageBG.position
	BG_fix_pos = $FixShipPage/FixPageBG.position
	
	BG_landing_size = $landingPageBG.size
	BG_craft_size = $CraftingPage/CraftingPageBG.size
	BG_tech_size = $TechTreePage/TechPageBG.size
	BG_fix_size = $FixShipPage/FixPageBG.size
	
	starting = true
	$landingPageBG.modulate.a += -50*.01

	if visible:
		_eat()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		Input.set_custom_mouse_cursor(menu_cursor,Input.CURSOR_ARROW,Vector2(20,16))
	if starting == true:
		$WhitenBG.visible = true
		for i in 50:
			$landingPageBG.modulate.a += .01
			await get_tree().create_timer(0.01).timeout
		$LandingPage/GridContainer.visible = true
		starting = false
		$WhitenBG.visible = false
	if page_state == PAGE_STATE.LANDING:
		$landingPageBG.position = page_transition($landingPageBG.position,BG_landing_pos)
		$landingPageBG.size = page_transition($landingPageBG.size,BG_landing_size)
	if page_state == PAGE_STATE.CRAFTING:
		$landingPageBG.position = page_transition($landingPageBG.position,BG_craft_pos)
		$landingPageBG.size = page_transition($landingPageBG.size,BG_craft_size)
	if page_state == PAGE_STATE.TECH:
		$landingPageBG.position = page_transition($landingPageBG.position,BG_tech_pos)
		$landingPageBG.size = page_transition($landingPageBG.size,BG_tech_size)
	if page_state == PAGE_STATE.FIX:
		$landingPageBG.position = page_transition($landingPageBG.position,BG_fix_pos)
		$landingPageBG.size = page_transition($landingPageBG.size,BG_fix_size)

func _on_craft_button_pressed() -> void:
	$LandingPage.visible = false
	$CraftingPage.visible = true
	page_state = PAGE_STATE.CRAFTING

func _on_tech_tree_button_pressed() -> void:
	$LandingPage.visible = false
	$TechTreePage.visible = true
	page_state = PAGE_STATE.TECH

func _on_fix_ship_button_pressed() -> void:
	$LandingPage.visible = false
	$FixShipPage.visible = true
	page_state = PAGE_STATE.FIX

func _on_end_night_button_pressed() -> void:
	$DarkenBG.visible = true
	$LandingPage/GridContainer/CraftButton.disabled = true
	$LandingPage/GridContainer/TechTreeButton.disabled = true
	$LandingPage/GridContainer/LFixShipButton.disabled = true
	$LandingPage/GridContainer/EndNightButton.disabled = true
	$EndNightCheckBox.visible = true

func _on_back_from_cft_pressed() -> void:
	$CraftingPage.visible = false
	$LandingPage.visible = true
	page_state = PAGE_STATE.LANDING

func _on_back_from_tt_pressed() -> void:
	$TechTreePage.visible = false
	$LandingPage.visible = true
	page_state = PAGE_STATE.LANDING

func _on_back_from_fix_pressed() -> void:
	$FixShipPage.visible = false
	$LandingPage.visible = true
	page_state = PAGE_STATE.LANDING
	
func _on_main_menu_button_pressed() -> void:
	$CheckMainMenu.visible = true
	$LandingPage/GridContainer/CraftButton.disabled = true
	$LandingPage/GridContainer/LFixShipButton.disabled = true
	$LandingPage/GridContainer/TechTreeButton.disabled = true
	$LandingPage/GridContainer/EndNightButton.disabled = true
	$LandingPage/GridContainer/MainMenuButton.disabled = true

func _on_en_yes_button_pressed() -> void:
	#release_focus()
	end_day()

func _on_en_no_button_pressed() -> void:
	$DarkenBG.visible = false
	$LandingPage/GridContainer/CraftButton.disabled = false
	$LandingPage/GridContainer/TechTreeButton.disabled = false
	$LandingPage/GridContainer/LFixShipButton.disabled = false
	$LandingPage/GridContainer/EndNightButton.disabled = false
	$EndNightCheckBox.visible = false
	
func _eat():
	if Save.get_value(1, "FOO", 0) < 10:
		if Save.get_value(1, "WAT", 0) <10:
			_lose_game($eating/Window/nofoodwater)
		else:
			_lose_game($eating/Window/nofood)
	elif Save.get_value(1, "WAT", 0) <10:
		_lose_game($eating/Window/nowater)
	else:
		Save.set_value(1, "FOO", Save.get_value(1, "FOO", 0) -10)
		Save.set_value(1, "WAT", Save.get_value(1, "WAT", 0) -10)
		$eating/Window/EatingGridContainer.visible = true
		await get_tree().create_timer(1.0).timeout
		for i in 100:
			$eating/Window/EatingGridContainer.modulate.a += -.01
			$eating/Window.modulate.a += -.01
			await get_tree().create_timer(0.01).timeout
		$eating/Window.visible = false
		$eating/Window/EatingGridContainer.visible = false
	
func end_day():
	print("Start playing sleeping sounds.")
	for i in 100:
		$".".modulate.r += -.01
		$".".modulate.b += -.01
		$".".modulate.g += -.01
		await get_tree().create_timer(0.01).timeout
	
	Save.set_value(1, "DAY", Save.get_value(1, "DAY", 0)+1)
	Save.set_value(1, "Phase", 0)
	Save.save_file(1)
	LevelManager.load_day()

func page_transition(start_page,end_page):
	return lerp(start_page,end_page,lerp(0,1,.025))

func win_game():
	print("You win the game!")
	Save.set_value(1, "WINLOSE", 1)
	$"eating/End game timer".start()
	$win.visible = true

func _lose_game(node):
	$eating.visible = true
	$eating/Window.visible = true
	node.visible = true
	$"eating/End game timer".start()
	await get_tree().create_timer(2).timeout
	for i in 100:
		$".".modulate.r += -.01
		$".".modulate.b += -.01
		$".".modulate.g += -.01
		await get_tree().create_timer(0.01).timeout

func _on_end_game_timer_timeout() -> void:
	LevelManager.load_post_game()


func _on_gametimer_timeout() -> void:
	Save.set_value(1, "TOTALTIME",Save.get_value(1, "TOTALTIME",0)+0.05)
