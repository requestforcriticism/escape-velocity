extends Area2D

@export var type:String

@export var coltype = ["BLU","RED","GRE","YEL","ORA","PUR"]

func _ready() -> void:
	if $AnimatedSprite2D.sprite_frames.get_animation_names().has(type):
		name = type
		$AnimatedSprite2D.animation = type
		$AnimatedSprite2D.play(type)
	else:
		name = "BLU"
		$AnimatedSprite2D.animation = "BLU"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	hide()
	queue_free()
	
