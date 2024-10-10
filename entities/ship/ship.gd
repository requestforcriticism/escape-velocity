extends StaticBody2D

@export var collectables:int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func collect(item):
	var current_item_count = Save.get_value(1, item, 0)
	Save.set_value(1, item, current_item_count + 1)
	Save.save_file(1)
	
	
