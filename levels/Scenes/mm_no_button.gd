extends Button


func _on_pressed() -> void:
	$"../../../Sounds/buttonpressed".play()
	
	
	$"../..".visible = false
	$"../../../LandingPage/GridContainer/CraftButton".disabled = false
	$"../../../LandingPage/GridContainer/LFixShipButton".disabled = false
	$"../../../LandingPage/GridContainer/TechTreeButton".disabled = false
	$"../../../LandingPage/GridContainer/EndNightButton".disabled = false
	$"../../../LandingPage/GridContainer/MainMenuButton".disabled = false
	
	


func _on_mouse_entered() -> void:
	$"../../../Sounds/buttonhovered".play()
