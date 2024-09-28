extends StaticBody2D

@export var bullet_scene : PackedScene
@export var hp = 50
@export var drops: Array[PackedScene] = []

var shoot_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func attack():
	var shoot_angle = deg_to_rad((shoot_state * 90) % 360)
	shoot_bullet(shoot_angle, 1, 10, 1)
	shoot_state += 1

func shoot_bullet(angle, expiration, damage, size):
	var bullet = bullet_scene.instantiate()
	var velocity = Vector2(150.0, 0.0)
	bullet.linear_velocity = velocity.rotated(angle)
	#bullet.position.x = bullet.position.x + randi_range(-32, 32)
	#new_bullet.position.x = position.x
	#bullet.position.y = bullet.position.y + randi_range(-32, 32)
	#new_bullet.position.y = position.y
	add_child(bullet)
