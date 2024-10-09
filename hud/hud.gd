extends CanvasLayer

var consum

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

	

#func _on_player_consumable_count(consum) -> void:
	
	#for i in consum.size:
		#if consum[i]



func _on_player_toggle_consumables() -> void:
	pass # Replace with function body.


func _on_player_hp_pack_count(hpPacks) -> void:
	print(hpPacks)
	$Label.text = str(hpPacks)
	pass # Replace with function body.


#how many of each comsumable does the player have?  Let's update it.
func _on_player_consum_count(cons) -> void:
	consum=cons
	


#cycle between the consumables
func _on_player_toggle_consum(toggle) -> void:
	consum.size()
	
	$ContConsum/Path2D/PathFollow2D.progress_ratio = 0
	$ContConsum/DBst.position = $ContConsum/Path2D/PathFollow2D.position
	$ContConsum/Path2D/PathFollow2D.progress_ratio = .5
	$ContConsum/SBst.position = $ContConsum/Path2D/PathFollow2D.position
	$ContConsum/Path2D/PathFollow2D.progress_ratio = 1
	$ContConsum/DRed.position = $ContConsum/Path2D/PathFollow2D.position
