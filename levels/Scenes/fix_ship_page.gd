extends Control

	#		= ["BLU","IRO"	,"OIL"	,"WAT"	,"URA"	,"FOO"	,"COM"	]
var fix_req = [[0	,10	  	,0		,0	  	,0		,0		,1		], #to fix Lvl 1
				[0	,20	  	,5		,5	  	,1		,0		,2		], #to fix Lvl 2
				[0	,40	  	,10		,10	  	,5		,0		,4		], #to fix Lvl 3
				[0	,70	  	,20		,20	  	,10		,0		,7		], #to fix Lvl 4
				[0	,110	,40		,40	  	,20		,40		,11		]] #to fix Lvl 5

var col_path_names = ["BlueCost","IronCost","OilCost","WaterCost","UraniumCost","FoodCost","ComputerChipCost"]
var col_path_images = ["BLU","IRO","OIL","WAT","URA","FOO","COM"]

var ND_path = "./FixShipCOST"

var fix_progress:int
var restest:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fix_progress = Save.get_value(1, "SHIPREPAIR", 0)
	$FixedShipProgressBar.value = fix_progress*20
	#print(fix_req)
	#print(fix_req.size())
	#print(fix_req[0].size())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fix_progress <=4:
		show_collectables_for_fixing(ND_path,fix_req[fix_progress])
	$Available/FoodShipAmount.text = str(Save.get_value(1, "FOO", 0))
	$Available/WaterShipAmount.text = str(Save.get_value(1, "WAT", 0))
	$Available/OilShipAmount.text = str(Save.get_value(1, "OIL", 0))
	$Available/IronShipAmount.text = str(Save.get_value(1, "IRO", 0))
	$Available/UraniumShipAmount.text = str(Save.get_value(1, "URA", 0))
	$Available/CompChipShipAmount.text = str(Save.get_value(1, "COM", 0))
	

func show_collectables_for_fixing(ND,cons_name):
	for j in cons_name.size():
		if cons_name[j] > 0:
			get_node(str(ND,"/",col_path_names[j])).text = str(" ",cons_name[j])
			get_node(str(ND,"/",col_path_names[j])).visible = true
			get_node(str(ND,"/",col_path_images[j])).visible = true
		else:
			get_node(str(ND,"/",col_path_names[j])).visible = false
			get_node(str(ND,"/",col_path_images[j])).visible = false

func _on_fix_ship_button_pressed() -> void:
	try_fix(fix_req[fix_progress],$FixShipButton)
	pass # Replace with function body.

func try_fix(typeCost,buttonPath):
	restest = true
	for i in col_path_images.size():
		if typeCost[i] > Save.get_value(1,col_path_images[i], 0):
			restest = false
			break
	if restest == true:
		for i in col_path_images.size():
			if typeCost[i] > 0:
				Save.set_value(1,col_path_images[i],Save.get_value(1,col_path_images[i], 0)-typeCost[i])
		fix_progress += 1
		Save.set_value(1, "SHIPREPAIR", fix_progress)
		$FixedShipProgressBar.value = fix_progress*20
		if fix_progress == 5:
			$"..".win_game()
	else:
		cant_craft(buttonPath)

func cant_craft(Nname):
	Nname.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	Nname.modulate = Color.WHITE