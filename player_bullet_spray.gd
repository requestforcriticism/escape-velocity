extends Area2D

@export var speed = 800
@export var damage:float
@export var direction:Vector2

func _ready():
	name = "playerbullet"

func _process(delta):
	position += direction * delta * speed

func _on_die_timer_timeout():
	_kill_bullet()

func _on_area_entered(area: Area2D) -> void:
	if area.name.left(12) != "playerbullet":
		_kill_bullet()

func _kill_bullet():
	hide()
	queue_free()
