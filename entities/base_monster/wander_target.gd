extends Area2D

signal entered
signal expired

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	entered.emit(body)


func _on_expire_timer_timeout():
	expired.emit()
	queue_free()
