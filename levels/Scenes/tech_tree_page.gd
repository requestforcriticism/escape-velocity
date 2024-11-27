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

	if Save.get_value(1, str("LogicUnlock"), 1) == 2:
		$VBoxContainer/BonusHP.visible = true
		$VBoxContainer/CapacitorCapacitance.visible = true
		$VBoxContainer/ShootSpeed.visible = true
		var countHP = 0
		var countCC = 0
		var countSS = 0
		for i in 4:
			if Save.get_value(1, str("Health",i+1), 1) == 2:
				countHP += 1
			if Save.get_value(1, str("Capacitor",i+1), 1) == 2:
				countCC += 1
			if Save.get_value(1, str("Damage",i+1), 1) == 2:
				countSS += 1
		if countHP > 0:
			$VBoxContainer/HPRegen.visible = true
			$VBoxContainer/HPRegen.text = str("Health Regen: +",countHP,"HP/sec")
		if countCC > 0:
			$VBoxContainer/CapacitorRegen.visible = true
			$VBoxContainer/CapacitorRegen.text = str("Capacitor Regen: +",100*(countCC*.25),"%")
		if countSS > 0:	
			$VBoxContainer/WeaponDmg.visible = true
			$VBoxContainer/WeaponDmg.text = str("Weapon Damage: +",100*(countSS*.25),"%")
		if Save.get_value(1, str("MissileWeapon"), 0) == 2:
			$VBoxContainer/Missileunlocked.visible = true
		if Save.get_value(1, str("SprayWeapon"), 0) == 2:
			$VBoxContainer/SprayUnlocked.visible = true
		
		$VBoxContainer/BonusHP.text = str("Bonus HP: +",100*(.05+countHP*.25),"%")
		$VBoxContainer/CapacitorCapacitance.text = str("Capacitor Capacitance: +",100*(.05+countCC*.25),"%")
		$VBoxContainer/ShootSpeed.text = str("Shoot Speed: +",100*(.05+countSS*.10),"%")
