extends AnimatedSprite2D

class_name TechTreeLine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func unlock_line():
	play("unlocked")
	
func lock_line():
	play("locked")
