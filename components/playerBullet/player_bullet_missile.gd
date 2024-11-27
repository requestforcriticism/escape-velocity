extends Area2D

@export var explosion: PackedScene

@export var speed = 400
@export var damage:float
@export var explosiondamage:float
@export var direction:Vector2

func _ready():
	damage = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * delta * speed

func _on_die_timer_timeout():
	explode()

func _on_area_entered(area: Area2D) -> void:
	print(area.name.left(9))
	if area.name.left(9) != "explosion":
		explode()
	
func explode():
	var new_expolsion = explosion.instantiate()
	new_expolsion.damage = explosiondamage
	new_expolsion.position = global_position
	add_sibling(new_expolsion)
	
	hide()
	queue_free()
