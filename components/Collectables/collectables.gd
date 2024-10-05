extends Area2D

@export var type:String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = type
	if type == "BLU":
		modulate = "blue"
	elif type == "RED":
		modulate = "red"
	elif type == "GRE":
		modulate = "green"
	elif type == "YEL":
		modulate = "yellow"
	elif type == "ORA":
		modulate = "orange"
	elif type == "PUR":
		modulate = "purple"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	hide()
	queue_free()
	
