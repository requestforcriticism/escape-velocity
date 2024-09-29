extends RigidBody2D

@export var speed = 500
@export var velocity:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (velocity) * delta * speed


func _on_die_timer_timeout():
	queue_free()
