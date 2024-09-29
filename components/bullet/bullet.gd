extends RigidBody2D

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_die_timer_timeout():
	queue_free()
