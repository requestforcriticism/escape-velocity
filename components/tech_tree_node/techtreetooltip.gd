extends Control

@export var title:String
@export var description:String
#@export var Costs:Array =[]

var col_path_names = ["BlueCost","IronCost","OilCost","WaterCost","UraniumCost","FoodCost","ComputerChipCost"]
var col_path_images = ["BLU","IRO","OIL","WAT","URA","FOO","COM"]

@export var ND_path = "./CanvasLayer/PopupPanel/GridContainer/FixShipCOST"

func _process(delta):
	#if Costs != []:
		#print("tooltip",Costs)
		#show_collectables_for_fixing(ND_path,Costs)
		pass


# Called when the node enters the scene tree for the first time.
func PopupPanel(slot: Rect2i,item):
	var mouse_pos = get_viewport().get_mouse_position()
	var padding = 16
	#var correction = Vector2i(slot.size.x+ padding,-32)
	var correction = Vector2i(-(slot.size.x+$CanvasLayer/PopupPanel.size.x+ padding),-32)
	var fix = get_viewport().get_visible_rect().size

	$CanvasLayer/PopupPanel.popup(Rect2i( slot.position + Vector2i(fix/2) + correction, $CanvasLayer/PopupPanel.size))

func HidePopupPanel():
	$CanvasLayer/PopupPanel.hide()

func show_collectables_for_fixing(ND,cons_name):
	for j in cons_name.size():
		if cons_name[j] > 0:
			get_node(str(ND,"/",col_path_names[j])).text = str(" ",cons_name[j])
			get_node(str(ND,"/",col_path_names[j])).visible = true
			get_node(str(ND,"/",col_path_images[j])).visible = true
		else:
			get_node(str(ND,"/",col_path_names[j])).visible = false
			get_node(str(ND,"/",col_path_images[j])).visible = false

func info_setup(title,desc,Costs,purchased,shipreq):
	if purchased:
		$CanvasLayer/PopupPanel/GridContainer/Purchased.visible = true
		$CanvasLayer/PopupPanel/GridContainer/cost.visible = false
		$CanvasLayer/PopupPanel/GridContainer/FixShipCOST.visible = false
	else:
		if shipreq<=Save.get_value(1, "SHIPREPAIR",0):
			$CanvasLayer/PopupPanel/GridContainer/shipfixedreq.visible=false
		else:
			$CanvasLayer/PopupPanel/GridContainer/shipfixedreq.visible=true
			$CanvasLayer/PopupPanel/GridContainer/shipfixedreq.text = str("SHIP REPAIR ",20*shipreq,"% REQUIRED")
		show_collectables_for_fixing(ND_path,Costs)
	$CanvasLayer/PopupPanel/GridContainer/title.text = title
	$CanvasLayer/PopupPanel/GridContainer/desc.text = desc
