extends TextureRect

var current_sta_left
var current_sta_right
var dashrdy:bool
var dashing:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dashrdy = true
	current_sta_left = 100
	current_sta_right = 100
	$StaminaProgressBar.value=100
	$StaminaProgressBar2.value=100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_change_left_bat(current_sta_left,100)
	current_sta_left += -1
	if current_sta_left <= 0:
		current_sta_left = 100
		
	if dashrdy:
		$AnimatedSprite2DFire.play()
		await get_tree().create_timer(0.2).timeout
		
	if dashing > 0:
		dashing += -1
		$AnimatedSprite2DFire.play("dash")
		if dashing == 0:
			$AnimatedSprite2DFire.pause()
			$AnimatedSprite2DFire.visible = false
	if current_sta_right <=0:
		current_sta_right =100
		_change_right_bat(current_sta_right,100)
		
	 
func _change_left_bat(stamina_changed,maxStamina):
	$StaminaProgressBar.value = 100*stamina_changed/maxStamina
	if $StaminaProgressBar.value >=50:
		$StaminaProgressBar.modulate = "green"
	elif $StaminaProgressBar.value >=20:
		$StaminaProgressBar.modulate = "yellow"
	else:
		$StaminaProgressBar.modulate = "red"

func _change_right_bat(stamina_changed,maxStamina):
	$StaminaProgressBar2.value = 100*stamina_changed/maxStamina
	if $StaminaProgressBar2.value >=50:
		$StaminaProgressBar2.modulate = "green"
	elif $StaminaProgressBar2.value >=20:
		$StaminaProgressBar2.modulate = "yellow"
	else:
		$StaminaProgressBar2.modulate = "red"


func _on_dash_timer_timeout() -> void:
	current_sta_right += -25
	_change_right_bat(current_sta_right,100)
	dashrdy = true
	$AnimatedSprite2DFire.visible = true
	dashing = 10
