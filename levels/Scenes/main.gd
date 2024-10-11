extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.set_main(self)
	LevelManager.load_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
