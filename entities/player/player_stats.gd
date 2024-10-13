extends Node

@export var maxHealth:int
@export var currentHealth:int
@export var healthRegen:int  #A techtree upgrade may improve this.
@export var speed:int
@export var maxStamina:int
@export var currentStamina = maxStamina
@export var dashStaminaCost = 25
@export var resourceA:int
@export var StaRegenBase:float = .05  #This just lowers the wait time between the StaminaRegen timer
@export var StaWaitTimeBase:float = 1 #The initial wait time for stamina to start regenerating
@export var Damage:int
@export var ShootSpeed:float
@export var DamageReduction:float
	
func set_MaxHP(maxHP):
	maxHealth = maxHP
	currentHealth = maxHP
	
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

func get_HealthRegen():
	return healthRegen
	
func Regen_HP():
	set_currentHP(healthRegen)

func set_MaxSTA(maxSTA):
	maxStamina = maxSTA
	currentStamina = maxSTA

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

func get_StaRegen():
	return StaRegenBase

func set_speed(SPD):
	speed = SPD

func get_speed():
	return speed
	
func set_DMG(DMG):
	Damage = DMG

func get_DMG():
	return Damage

func set_shootSpeed(ASPD):
	ShootSpeed = ASPD

func get_shootSpeed():
	return ShootSpeed

func set_DMGReduction(val):
	DamageReduction = val

func get_DMGReduction():
	return DamageReduction
