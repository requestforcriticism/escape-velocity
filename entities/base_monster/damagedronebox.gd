extends Area2D

@export var damage:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = $"..".damage
	pass # Replace with function body.
