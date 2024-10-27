extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Available/FoodShipAmount.text = str(Save.get_value(1, "FOO", 0))
	$Available/WaterShipAmount.text = str(Save.get_value(1, "WAT", 0))
	$Available/OilShipAmount.text = str(Save.get_value(1, "OIL", 0))
	$Available/IronShipAmount.text = str(Save.get_value(1, "IRO", 0))
	$Available/UraniumShipAmount.text = str(Save.get_value(1, "URA", 0))
	$Available/CompChipShipAmount.text = str(Save.get_value(1, "COM", 0)) 
