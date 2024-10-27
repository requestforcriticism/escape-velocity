extends Control

var Days
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	$LandingPage/GridContainer/FixShipButton.disabled = true
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

func _on_en_yes_button_pressed() -> void:
	release_focus()
	end_day()

func _on_en_no_button_pressed() -> void:
	$DarkenBG.visible = false
	$LandingPage/GridContainer/CraftButton.disabled = false
	$LandingPage/GridContainer/TechTreeButton.disabled = false
	$LandingPage/GridContainer/FixShipButton.disabled = false
	$LandingPage/GridContainer/EndNightButton.disabled = false
	$EndNightCheckBox.visible = false
	pass # Replace with function body.
	
func end_day():
	print("ending the night")
	print("Start playing sleeping sounds.")
	for i in 100:
		$".".modulate.r += -.01
		$".".modulate.b += -.01
		$".".modulate.g += -.01
		await get_tree().create_timer(0.01).timeout
	
	Days = Save.get_value(1, "DAY", 0)
	Save.set_value(1, "DAY", Days+1)
	LevelManager.load_day()

func page_transition(start_page,end_page):
	return lerp(start_page,end_page,lerp(0,1,.025))

func win_game():
	print("You win the game!")
	LevelManager.load_post_game()
