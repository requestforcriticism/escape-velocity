extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$BoxContainer/Left/Basevalue.text = str(Save.get_value(1, "BASESHOTS", 0))
	$BoxContainer/Left/missilevalue.text = str(Save.get_value(1, "MISSILESHOTS", 0))
	$BoxContainer/Left/SPvalue.text = str(Save.get_value(1, "SPRAYSHOTS", 0))
	$BoxContainer/Left/DamageTakenvalue.text = str(Save.get_value(1, "DAMAGET", 0))
	$BoxContainer/Left/Distancetraveledvalue.text = str(snapped(Save.get_value(1, "DISTRAVEL", 0)/32000.0,0.01)," km")
	$BoxContainer/Left/ResourceMonstervalue.text = str(Save.get_value(1, "BRDEF", 0))
	$BoxContainer/Left/OtherMonstersvalue.text = str(Save.get_value(1, "MONDEF", 0))
	$BoxContainer/Right/Daysvalue.text = str(Save.get_value(1, "DAY", 0))
	$BoxContainer/Right/Foodvalue.text = str(Save.get_value(1, "COLLECTEDFOO", 0))
	$BoxContainer/Right/Watervalue.text = str(Save.get_value(1, "COLLECTEDWAT", 0))
	$BoxContainer/Right/Ironvalue.text = str(Save.get_value(1, "COLLECTEDIRO", 0))
	$BoxContainer/Right/Oilvalue.text = str(Save.get_value(1, "COLLECTEDOIL", 0))
	$BoxContainer/Right/Uraniumvalue.text = str(Save.get_value(1, "COLLECTEDURA", 0))
	$BoxContainer/Right/ComputerChipvalue.text = str(Save.get_value(1, "COLLECTEDCOM", 0))
	$timeplayed.text = str(time_convert(floori(Save.get_value(1, "TOTALTIME",0))))
	
	if Save.get_value(1, "WINLOSE", 0):
		$Winner.visible = true
	else:
		$Failed.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_returnto_start_pressed() -> void:
	LevelManager.load_start()

func time_convert(time_in_sec):
	print(time_in_sec)
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	var hours = (time_in_sec/60/60)%60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
