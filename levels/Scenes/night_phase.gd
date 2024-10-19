extends Control

var Days
var starting:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting = true
	$LandingPage/landingPageBG.modulate.a += -50*.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if starting == true:
		$WhitenBG.visible = true
		for i in 50:
			$LandingPage/landingPageBG.modulate.a += .01
			await get_tree().create_timer(0.01).timeout
		$LandingPage/GridContainer.visible = true
		starting = false
		$WhitenBG.visible = false

func _on_craft_button_pressed() -> void:
	$LandingPage.visible = false
	$CraftingPage.visible = true

func _on_tech_tree_button_pressed() -> void:
	$LandingPage.visible = false
	$TechTreePage.visible = true

func _on_fix_ship_button_pressed() -> void:
	print("You're fixing the ship!")

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

func _on_back_from_tt_pressed() -> void:
	$TechTreePage.visible = false
	$LandingPage.visible = true


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
