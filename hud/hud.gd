extends CanvasLayer

@export var collected : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func start_day(dayLength):
	$Container/DayTimeTracker/Path2D/PathFollow2D.progress_ratio = 0
	$Container/DayTimeTracker/DayTimer.wait_time = dayLength/100.0
	$Container/DayTimeTracker/DayTimer.start()
	$Container/DayTimeTracker/AnimatedSprite2D.play()
	
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
	$Container/DayTimeTracker/Path2D/PathFollow2D.progress_ratio += .01
	$Container/DayTimeTracker/AnimatedSprite2D.position = $Container/DayTimeTracker/Path2D/PathFollow2D.position


func _on_player_gathered(colname) -> void:
	print("here")
	var new_col = collected.instantiate()
	new_col.position = Vector2(200,200)
	
	#var new_bullet = playerBullet.instantiate()
		#new_bullet.position = $Marker2D.global_position
		#new_bullet.direction = lastlook.normalized()
		#add_sibling(new_bullet)
	pass # Replace with function body.
