extends TextureRect

@export var playerBullet : PackedScene

var shootRdy:bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shootRdy == true:
			var new_bullet = playerBullet.instantiate()
			new_bullet.rotation = PI
			new_bullet.damage = 0
			new_bullet.scale = Vector2(4,4)
			new_bullet.position = $Marker2D.position
			new_bullet.direction = Vector2(-1,0)
			add_child(new_bullet)
			shootRdy = false
			$ShootTimer.start()

func _on_shoot_timer_timeout() -> void:
	shootRdy = true
