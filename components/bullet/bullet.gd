extends Area2D

@export var speed = 500
@export var direction:Vector2
@export var damage:int

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * delta * speed

func _on_die_timer_timeout():
	queue_free()
