extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_player_stamina_changed(stamina_changed,maxStamina) -> void:
	$StaminaProgressBar.value = 100*stamina_changed/maxStamina


func _on_player_health_changed(currentHealth,maxHealth) -> void:
	$HPProgressBar.value = 100*currentHealth/maxHealth
	pass # Replace with function body.
