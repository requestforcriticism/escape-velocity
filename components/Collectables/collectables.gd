extends Area2D

@export var type:String
@export var return_speed = 2.0
@export var coltype = ["BLU","RED","GRE","YEL","ORA","PUR"]

func _ready() -> void:
	if $AnimatedSprite2D.sprite_frames.get_animation_names().has(type):
		name = type
		$AnimatedSprite2D.animation = type
		$AnimatedSprite2D.play(type)
	else:
		name = "BLU"
		$AnimatedSprite2D.animation = "BLU"
	
var dest
var is_drifting = false
func drift(target_pos):
	is_drifting = true
	dest = target_pos
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_drifting and dest != null:
		position = position.lerp(dest, delta * return_speed)
	pass

func _on_area_entered(area: Area2D) -> void:
	#hide()
	#queue_free()
	pass
	
