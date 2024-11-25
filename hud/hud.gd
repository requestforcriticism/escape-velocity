extends CanvasLayer

var consum
var DayTimeLeft:int
var Daywords = false
var OneMinWarn = false
var countdown = false
var HarvCount:int
var HarvTotal:int
var ArrowToShip
enum PLAYER_WEAPONS { BASE, MISSILE, SPRAY}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaminaProgressBar.modulate = "green"
	$HPProgressBar/HeartSprite2D.modulate = Color.RED
	$ContConsum/GridContainer/StaRegDur.text = str("0 secs")
	$ContConsum/GridContainer/DmgBstDur.text = str("0 secs")
	$ContConsum/GridContainer/DmgRedDur.text = str("0 secs")
	$ContDTT/AnimatedSprite2D.position = $ContDTT/Path2D/PathFollow2D.position

func start_day(dayLength):
	DayTimeLeft = dayLength
	displayDay()
	$ContDTT/Timer.text = str(time_convert(DayTimeLeft))
	$ContDTT/Path2D/PathFollow2D.progress_ratio = 0
	$ContDTT/DayTrackerTimer.wait_time = dayLength/100.0
	$ContDTT/DayTrackerTimer.start()
	$ContDTT/AnimatedSprite2D.play()
	
func _process(delta: float) -> void:
	DayTimeLeft = $"../../..".dayTimeLeft
	$ContDTT/Timer.text = str(time_convert(DayTimeLeft))
	if DayTimeLeft == 60:
		OneMinWarn = true
		#$Timer.start()
	if DayTimeLeft <= 10 && DayTimeLeft > 0:
		#$Timer.start()
		countdown = true
	point_arrow_to_ship()

func _on_player_stamina_changed(stamina_changed,maxStamina) -> void:
	$StaminaProgressBar.value = 100*stamina_changed/maxStamina
	if $StaminaProgressBar.value >=50:
		$StaminaProgressBar.modulate = "green"
	elif $StaminaProgressBar.value >=20:
		$StaminaProgressBar.modulate = "yellow"
	else:
		$StaminaProgressBar.modulate = "red"

func _on_player_health_changed(currentHealth,maxHealth) -> void:
	if $HPProgressBar.value > 100*currentHealth/maxHealth:
		$HPProgressBar/HeartSprite2D.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
		$HPProgressBar/HeartSprite2D.modulate = Color.RED
	$HPProgressBar.value = 100*currentHealth/maxHealth

func _on_player_gathered(colname) -> void:
	$ContBp/AnimatedSprite2D2.animation = colname
	$ContBp/AnimatedSprite2D2.show()
	for i in 6:
		$ContBp/AnimatedSprite2D2.play()
		$ContBp/Path2D/PathFollow2D.progress_ratio = i/5.0
		$ContBp/AnimatedSprite2D2.position = $ContBp/Path2D/PathFollow2D.position
		await get_tree().create_timer(0.01).timeout
	$ContBp/AnimatedSprite2D2.hide()	

func _on_player_hp_pack_count(hpPacks) -> void:
	$HealthPackContainer/Label.text = str(hpPacks)

func _on_player_on_harvester_count_changed(amt):
	HarvCount = amt
	update_harvestor_count()

func _on_player_on_harvester_max_changed(amt):
	HarvTotal = amt
	update_harvestor_count()
	
func update_harvestor_count():
	$HarvesterControl/HarvesterCount.text = str(HarvCount," / ",HarvTotal)

func _on_player_cons_duration(consDur) -> void:
	if consDur[0] > 0:
		$ContConsum/GridContainer/StaRegDur.text = str(consDur[0],"secs")
		$ContConsum/GridContainer/StaReg.visible = true
		$ContConsum/GridContainer/StaRegDur.visible = true
	elif consDur[0] == 0:
		$ContConsum/GridContainer/StaReg.visible = false
		$ContConsum/GridContainer/StaRegDur.visible = false
		
	if consDur[1] > 0:
		$ContConsum/GridContainer/DmgBstDur.text = str(consDur[1],"secs")
		$ContConsum/GridContainer/DmgBst.visible = true
		$ContConsum/GridContainer/DmgBstDur.visible = true
	elif consDur[1] == 0:
		$ContConsum/GridContainer/DmgBst.visible = false
		$ContConsum/GridContainer/DmgBstDur.visible = false
		
	if consDur[2] > 0:
		$ContConsum/GridContainer/DmgRedDur.text = str(consDur[2],"secs")
		$ContConsum/GridContainer/DmgRed.visible = true
		$ContConsum/GridContainer/DmgRedDur.visible = true
	elif consDur[2] == 0:
		$ContConsum/GridContainer/DmgRed.visible = false
		$ContConsum/GridContainer/DmgRedDur.visible = false

func displayDay():
	#$Timer.start()
	$DayNumber.text = str("Day ",Save.get_value(1, "DAY", 0))
	Daywords = true

func _on_timer_timeout() -> void:
	if Daywords == true:
		Daywords = type_in_letters($DayNumber)
	if OneMinWarn == true:
		OneMinWarn = letters_pop_out($OneMinWarning,80,.02)
	if countdown == true:
		$EndDayCountdown.text = str(DayTimeLeft)
		countdown = letters_pop_out($EndDayCountdown,80,.05)

func _on_day_tracker_timer_timeout() -> void:
	$ContDTT/Path2D/PathFollow2D.progress_ratio += .01
	$ContDTT/AnimatedSprite2D.position = $ContDTT/Path2D/PathFollow2D.position

	
func time_convert(time_in_sec):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	return "%02d:%02d" % [minutes, seconds]

#The visibile_ratio must start at 0.
func type_in_letters(LabelNode):
	LabelNode.visible_ratio +=.05
	if LabelNode.visible_ratio == 1:
		LabelNode.self_modulate.a += -.02
		if LabelNode.self_modulate.a <= 0:
			LabelNode.visible = false
			#$Timer.stop()
			return false
	return true

var FontStart:int = 1

func letters_pop_out(LabelNode,fontStart,modul):
	if fontStart > FontStart:
		FontStart = fontStart
	LabelNode.visible = true
	FontStart += 2
	LabelNode.add_theme_font_size_override("font_size",FontStart)
	LabelNode.self_modulate.a += -modul
	if LabelNode.self_modulate.a <= 0:
		LabelNode.visible = false
		LabelNode.self_modulate.a = 1
		#$Timer.stop()
		FontStart = 1
		return false
	else:
		return true

func point_arrow_to_ship():
	ArrowToShip = $"../../../Ship".global_position - $"../..".global_position
	$MiniMap/ArrowToShip.rotation = ArrowToShip.angle()


func _on_player_notenoughsta() -> void:
	$StaminaProgressBar/BatterySprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$StaminaProgressBar/BatterySprite2D.modulate = Color.BLACK


func _on_player_usingweapon(usingweapon) -> void:
	if usingweapon == PLAYER_WEAPONS.MISSILE:
		$Weapons/LeftBaseBG/LeftUsing.visible = false
		$Weapons/MiddleBaseBG/Middleusing.visible = true
		$Weapons/RightBaseBG/Rightusing.visible = false
	elif usingweapon == PLAYER_WEAPONS.SPRAY:
		$Weapons/LeftBaseBG/LeftUsing.visible = false
		$Weapons/MiddleBaseBG/Middleusing.visible = false
		$Weapons/RightBaseBG/Rightusing.visible = true
	else:
		$Weapons/LeftBaseBG/LeftUsing.visible = true
		$Weapons/MiddleBaseBG/Middleusing.visible = false
		$Weapons/RightBaseBG/Rightusing.visible = false
