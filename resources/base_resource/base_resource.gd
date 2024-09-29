extends StaticBody2D

signal health_changed

@export var bullet_scene : PackedScene
@export var maxHealth = 100
@export var currentHealth:int
@export var healthRegen = 1
@export var drops: Array[PackedScene] = []

var shoot_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	currentHealth = maxHealth
	$HealthBar.value = currentHealth
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentHealth <=0:
		dead()
	
func attack():
	var shoot_angle = deg_to_rad((shoot_state * 90) % 360)
	shoot_bullet(shoot_angle, 1, 10, 1)
	shoot_state += 1

func shoot_bullet(angle, expiration, damage, size):
	var bullet = bullet_scene.instantiate()
	var velocity = Vector2(150.0, 0.0)
	#bullet.linear_velocity = velocity.rotated(angle)
	
	bullet.direction = Vector2.RIGHT.rotated(angle)
	
	#var looking = Vector2(lookx,looky)
	#new_bullet.position = pos
	#new_bullet.direction = looking
	
	add_child(bullet)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("print bguy")
	currentHealth += -10
	$HealthBar.value = currentHealth
	#health_changed.emit(currentHealth,maxHealth)
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	
	
func dead():
	hide()
	queue_free()
	
