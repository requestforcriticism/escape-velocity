extends Area2D

@export var speed = 800
@export var damage:float
@export var direction:Vector2
var done:bool = false
var audiodone:bool = false

func _ready():
	name = "explosion"
	$AudioStreamPlayer.play()

func _process(delta):
	if done && audiodone:
		_kill_bullet()

func _on_animated_sprite_2d_animation_finished() -> void:
	hide()
	done = true
	damage = 0

func _on_audio_stream_player_finished() -> void:
	audiodone = true

func _kill_bullet():
	queue_free()
