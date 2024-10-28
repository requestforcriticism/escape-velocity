extends Control

	#				= ["BLU","IRO"	,"OIL"	,"WAT"	,"URA"	,"FOO"	,"COM"	]
var HLTHPCKCOST 	= [0	,0	  	,5		,5	  	,0		,0		,0		]
var STABSTCOST 		= [0	,7	  	,10		,3	  	,0		,0		,0		]
var DMGBSTCOST 		= [0	,3	  	,5		,2	  	,1		,0		,0		]
var DMGREDCOST 		= [0	,5	  	,3		,1	  	,1		,0		,0		]
var HarvesterCOST 	= [0	,10	  	,10		,0	  	,0		,0		,1		]

var consumable_names = ["HLTHPCKCOST","STABSTCOST","DMGBSTCOST","DMGREDCOST","HarvesterCOST"]
var col_path_names = ["BlueCost","IronCost","OilCost","WaterCost","UraniumCost","FoodCost","ComputerChipCost"]
var col_path_images = ["BLU","IRO","OIL","WAT","URA","FOO","COM"]

var ND_path = "./CraftOptionsGridContainer"

var restest:bool

func _ready() -> void:
	for i in consumable_names.size():
		show_collectables_for_crafting(ND_path,consumable_names[i])
	$CraftOptionsGridContainer/HLTPCKInInventory.text = str(Save.get_value(1, "HLTHPCK", 0))
	$CraftOptionsGridContainer/STABSTInInventory.text = str(Save.get_value(1, "STABST", 0))
	$CraftOptionsGridContainer/DMGBSTInInventory.text = str(Save.get_value(1, "DMGBST", 0))
	$CraftOptionsGridContainer/DMGREDInInventory.text = str(Save.get_value(1, "DMGRED", 0))
	$CraftOptionsGridContainer/HarversterInInventory.text = str(Save.get_value(1, "HARV", 0))

func _process(delta: float) -> void:
	$Available/FoodShipAmount.text = str(Save.get_value(1, "FOO", 0))
	$Available/WaterShipAmount.text = str(Save.get_value(1, "WAT", 0))
	$Available/OilShipAmount.text = str(Save.get_value(1, "OIL", 0))
	$Available/IronShipAmount.text = str(Save.get_value(1, "IRO", 0))
	$Available/UraniumShipAmount.text = str(Save.get_value(1, "URA", 0))
	$Available/CompChipShipAmount.text = str(Save.get_value(1, "COM", 0)) 

func show_collectables_for_crafting(ND,cons_name):
	var consCosts = get(cons_name)
	var consTypePath = str(ND,"/",cons_name)
	
	for j in consCosts.size():
		if consCosts[j] > 0:
			get_node(str(ND,"/",cons_name,"/",col_path_names[j])).text = str(consCosts[j])
			get_node(str(ND,"/",cons_name,"/",col_path_names[j])).visible = true
			get_node(str(ND,"/",cons_name,"/",col_path_images[j])).visible = true
		else:
			get_node(str(ND,"/",cons_name,"/",col_path_names[j])).visible = false
			get_node(str(ND,"/",cons_name,"/",col_path_images[j])).visible = false
	
func _on_hlthpck_create_button_pressed() -> void:
	try_craft(HLTHPCKCOST,"HLTHPCK",$CraftOptionsGridContainer/HLTPCKInInventory,$CraftOptionsGridContainer/HLTHPCKCreateButton)

func _on_stabst_create_button_pressed() -> void:
	try_craft(STABSTCOST,"STABST",$CraftOptionsGridContainer/STABSTInInventory,$CraftOptionsGridContainer/STABSTCreateButton)

func _on_dmgbst_create_button_pressed() -> void:
	try_craft(DMGBSTCOST,"DMGBST",$CraftOptionsGridContainer/DMGBSTInInventory,$CraftOptionsGridContainer/DMGBSTCreateButton)

func _on_dmgred_create_button_pressed() -> void:
	try_craft(DMGREDCOST,"DMGRED",$CraftOptionsGridContainer/DMGREDInInventory,$CraftOptionsGridContainer/DMGREDCreateButton)

func _on_harvester_create_button_pressed() -> void:
	try_craft(HarvesterCOST,"HARV",$CraftOptionsGridContainer/HarversterInInventory,$CraftOptionsGridContainer/HarvesterCreateButton)

func try_craft(typeCost,typeCons,invPath,buttonPath):
	restest = true
	for i in col_path_images.size():
		if typeCost[i] > Save.get_value(1,col_path_images[i], 0):
			restest = false
			break
	if restest == true:
		for i in col_path_images.size():
			if typeCost[i] > 0:
				Save.set_value(1,col_path_images[i],Save.get_value(1,col_path_images[i], 0)-typeCost[i])
		Save.set_value(1, typeCons, Save.get_value(1, typeCons, 0)+1)
		invPath.text = str(Save.get_value(1, typeCons, 0))
	else:
		cant_craft(buttonPath)

func cant_craft(Nname):
	Nname.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	Nname.modulate = Color.WHITE
