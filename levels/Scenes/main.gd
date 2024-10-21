extends Node2D

@export var end_scn : PackedScene
@export var day_scn : PackedScene
@export var night_scn : PackedScene
@export var tut_scn : PackedScene
@export var start_scn : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.end_scn = end_scn
	LevelManager.day_scn = day_scn
	LevelManager.night_scn = night_scn
	LevelManager.tut_scn = tut_scn
	LevelManager.start_scn = start_scn
	
	LevelManager.set_main(self)
	LevelManager.load_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
