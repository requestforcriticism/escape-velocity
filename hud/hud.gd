extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func start_day(dayLength):
	$DayTimeTracker/Path2D/PathFollow2D.progress_ratio = 0
	$DayTimeTracker/DayTimer.wait_time = dayLength/100.0
	$DayTimeTracker/DayTimer.start()
	$DayTimeTracker/AnimatedSprite2D.play()
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
	

func _on_player_stamina_changed(stamina_changed,maxStamina) -> void:
	$StaminaProgressBar.value = 100*stamina_changed/maxStamina


func _on_player_health_changed(currentHealth,maxHealth) -> void:
	$HPProgressBar.value = 100*currentHealth/maxHealth
	pass # Replace with function body.


func _on_day_timer_timeout() -> void:
	$DayTimeTracker/Path2D/PathFollow2D.progress_ratio += .01
	$DayTimeTracker/AnimatedSprite2D.position = $DayTimeTracker/Path2D/PathFollow2D.position
