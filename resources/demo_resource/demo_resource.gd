extends StaticBody2D

@export var bullet : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_bullet_timer_timeout():
	var new_bullet = bullet.instantiate()
	new_bullet.position.x = new_bullet.position.x + randi_range(-32, 32)
	#new_bullet.position.x = position.x
	new_bullet.position.y = new_bullet.position.y + randi_range(-32, 32)
	#new_bullet.position.y = position.y
	add_child(new_bullet)
