extends Area2D

@export var type:String

@export var coltype = ["BLU","RED","GRE","YEL","ORA","PUR"]

func _ready() -> void:
	name = type
	for i in coltype.size():
		if type == coltype[i]:
			$AnimatedSprite2D.animation = coltype[i]
			break	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	hide()
	queue_free()
	
