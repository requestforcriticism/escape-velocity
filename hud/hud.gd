extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HeartSprite2D.modulate = Color.RED


func start_day(dayLength):
	$ContDTT/DayTimeTracker/Path2D/PathFollow2D.progress_ratio = 0
	$ContDTT/DayTimeTracker/DayTimer.wait_time = dayLength/100.0
	$ContDTT/DayTimeTracker/DayTimer.start()
	$ContDTT/DayTimeTracker/AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	pass
	

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
		$HeartSprite2D.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
		$HeartSprite2D.modulate = Color.RED
	$HPProgressBar.value = 100*currentHealth/maxHealth
	
	

func _on_day_timer_timeout() -> void:
	$ContDTT/DayTimeTracker/Path2D/PathFollow2D.progress_ratio += .01
	$ContDTT/DayTimeTracker/AnimatedSprite2D.position = $ContDTT/DayTimeTracker/Path2D/PathFollow2D.position


func _on_player_gathered(colname) -> void:
	$ContBp/AnimatedSprite2D2.animation = colname
	$ContBp/AnimatedSprite2D2.show()
	for i in 6:
		$ContBp/AnimatedSprite2D2.play()
		$ContBp/Path2D/PathFollow2D.progress_ratio = i/5.0
		$ContBp/AnimatedSprite2D2.position = $ContBp/Path2D/PathFollow2D.position
		await get_tree().create_timer(0.01).timeout
	$ContBp/AnimatedSprite2D2.hide()	
	print("#",colname)

	

func _on_player_consumable_count(consum) -> void:
	$Label.text = str(consum[0])
	#for i in consum.size:
		#if consum[i]



func _on_player_toggle_consumables() -> void:
	pass # Replace with function body.
