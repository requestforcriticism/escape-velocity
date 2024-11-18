extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($ProgressBar)
	$ProgressBar.value = 100
	$ProgressBar/HeartSprite2D.modulate = Color.RED
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $ProgressBar.value <= 0:
		$ProgressBar.value = 100
	pass


func _on_area_2_ddetectenemybullet_area_entered(area: Area2D) -> void:
	$ProgressBar.value += -10
	$ProgressBar/HeartSprite2D.modulate = Color.WHITE
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$ProgressBar/HeartSprite2D.modulate = Color.RED
	$AnimatedSprite2D.modulate = Color.WHITE
