extends Area2D

@export var speed = 800
@export var direction:Vector2

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * delta * speed

func _on_die_timer_timeout():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	print("oww")
	hide()
	queue_free()
