extends Area2D

@export var speed = 800
@export var damage:float
@export var direction:Vector2

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_die_timer_timeout():
	hide()
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	hide()
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	hide()
	queue_free()
