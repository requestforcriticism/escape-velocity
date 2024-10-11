extends Node

@export var start_scn = load("res://levels/Scenes/post_game.tscn")
@export var end_scn : PackedScene
@export var day_scn : PackedScene
@export var night_scn : PackedScene
@export var tut_scn : PackedScene

var start_scn_path = "res://levels/Scenes/start_game_screen.tscn"
var end_scn_path = "res://levels/Scenes/post_game.tscn"
var day_scn_path = "res://levels/Scenes/day_phase.tscn"
var night_scn_path = "res://levels/Scenes/night_phase.tscn"
var tut_scn_path = "res://levels/Scenes/day_phase.tscn"

var loaded_scn = null
var main_ref = null

func _ready():
	pass

func set_main(ref):
	main_ref = ref

func load_start():
	load_level(start_scn_path)
	
func load_tutorial():
	# TODO load tut scn
	load_level(day_scn_path)
	
func load_post_game():
	load_level(end_scn_path)
	
func load_day():
	load_level(day_scn_path)
	
func load_night():
	load_level(night_scn_path)
	
func load_level(path):
	if loaded_scn != null:
		loaded_scn.queue_free()
	if main_ref != null:
		var next_scn = load(path).instantiate()
		main_ref.add_child(next_scn)
