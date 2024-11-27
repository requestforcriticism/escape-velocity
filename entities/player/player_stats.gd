extends Node

var maxHealth:int
var currentHealth:int
var healthRegen:int  #A techtree upgrade may improve this.
var speed:int
var maxStamina:int
var currentStamina = maxStamina
var dashStaminaCost = 25
var resourceA:int
var StaRegenBase:float = .05  #This just lowers the wait time between the StaminaRegen timer
var StaWaitTimeBase:float = 1 #The initial wait time for stamina to start regenerating
var Damage:float
var ShootSpeed:float
var DamageReduction:float
	
func set_MaxHP(maxHP):
	maxHealth = maxHP
	if Save.get_value(1, str("LogicUnlock"), 1) == 2:
			maxHealth += .05*maxHP
	for i in 4:
		if Save.get_value(1, str("Health",i+1), 1) == 2:
			maxHealth += .25*maxHP
	currentHealth = maxHealth
	
func get_MaxHP():
	return maxHealth

func set_currentHP(difference):
	currentHealth += difference
	if currentHealth > maxHealth:
		currentHealth = maxHealth
	elif currentHealth < 0:
		currentHealth = 0
		
func get_currentHP():
	return currentHealth

func set_HealthRegen(val):
	healthRegen = val
	for i in 4:
		if Save.get_value(1, str("Health",i+1), 1) == 2:
			healthRegen += 1

func get_HealthRegen():
	return healthRegen
	
func Regen_HP():
	set_currentHP(healthRegen)

func set_MaxSTA(maxSTA):
	maxStamina = maxSTA
	if Save.get_value(1, str("LogicUnlock"), 1) == 2:
			maxStamina += .05*maxSTA
	for i in 4:
		if Save.get_value(1, str("Capacitor",i+1), 1) == 2:
			maxStamina += .25*maxSTA
	currentStamina = maxStamina

func get_MaxSTA():
	return maxStamina
	
func set_currentSTA(difference):
	currentStamina += difference
	if currentStamina > maxStamina:
		currentStamina = maxStamina
	elif currentStamina < 0:
		currentStamina = 0
		
func get_currentSTA():
	return currentStamina

func set_StaInitialWait(StaWaitTime):
	StaWaitTimeBase = StaWaitTime

func get_StaInitialWait():
	return StaWaitTimeBase

func set_StaRegen(StaReg):
	StaRegenBase = StaReg
	for i in 4:
		if Save.get_value(1, str("Capacitor",i+1), 1) == 2:
			StaRegenBase += .25*StaReg

func get_StaRegen():
	return StaRegenBase

func set_speed(SPD):
	speed = SPD

func get_speed():
	return speed
	
func set_DMG(DMG):
	Damage = DMG
	for i in 4:
		if Save.get_value(1, str("Damage",i+1), 1) == 2:
			Damage += .25*DMG

func get_DMG():
	return Damage

func set_shootSpeed(ASPD):
	ShootSpeed = ASPD
	if Save.get_value(1, str("LogicUnlock"), 1) == 2:
			ShootSpeed += -.05*ASPD
	for i in 4:
		if Save.get_value(1, str("Damage",i+1), 1) == 2:
			ShootSpeed += -.10*ASPD

func get_shootSpeed():
	return ShootSpeed

func set_DMGReduction(val):
	DamageReduction = val

func get_DMGReduction():
	return DamageReduction
