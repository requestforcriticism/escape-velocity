extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_collectables_for_fixing($NightPhase/FixShipPage.ND_path,$NightPhase/FixShipPage.fix_req[$NightPhase/FixShipPage.fix_progress])
	$FixedShipProgressBar.value = $NightPhase/FixShipPage.fix_progress * 20
	
func _process(delta: float) -> void:
	pass

func show_collectables_for_fixing(ND,cons_name):
	for j in cons_name.size():
		if cons_name[j] > 0:
			get_node(str(ND,"/",$NightPhase/FixShipPage.col_path_names[j])).text = str(" ",cons_name[j])
			get_node(str(ND,"/",$NightPhase/FixShipPage.col_path_names[j])).visible = true
			get_node(str(ND,"/",$NightPhase/FixShipPage.col_path_images[j])).visible = true
		else:
			get_node(str(ND,"/",$NightPhase/FixShipPage.col_path_names[j])).visible = false
			get_node(str(ND,"/",$NightPhase/FixShipPage.col_path_images[j])).visible = false
	pass
