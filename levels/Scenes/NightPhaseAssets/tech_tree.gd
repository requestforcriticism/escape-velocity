extends Control

	#				= 	["BLU","IRO"	,"OIL"	,"WAT"	,"URA"	,"FOO"	,"COM"	]
var CostsLogicUnlock=		[0	,5	  	,3		,3	  	,0		,3		,0		]

var CostsHealthUp=			[[0	,10	  	,5		,1	  	,0		,0		,0		], #to Lvl 1
							[0	,20	  	,10		,5	  	,0		,0		,0		], #to Lvl 2
							[0	,40	  	,20		,10	  	,5		,0		,0		], #to Lvl 3
							[0	,70	  	,20		,20	  	,10		,0		,0		]] #to Lvl 4

var CostsStaUp=				[[0	,5	  	,8		,5	  	,0		,2		,0		], #to Lvl 1
							[0	,8	  	,14		,11	  	,2		,7		,0		], #to Lvl 2
							[0	,13	  	,28		,21	  	,6		,17		,0		], #to Lvl 3
							[0	,21	  	,41		,43	  	,11		,31		,0		]] #to Lvl 4

var CostsDmgUp=				[[0	,8	  	,8		,5	  	,0		,0		,0		], #to Lvl 1
							[0	,13	  	,13		,9	  	,2		,0		,0		], #to Lvl 2
							[0	,22	  	,22		,17	  	,7		,0		,0		], #to Lvl 3
							[0	,34	  	,34		,28	  	,12		,0		,0		]] #to Lvl 4

var CostsMissile=			[0	,30	  	,20		,10	  	,3		,0		,2		]

var CostsSpray=				[0	,20	  	,30		,20	  	,2		,0		,2		]

var DescLogicUnlock: String = "+5% Max HP
+5% Max Capacitor Capacity
-5% Shoot Speed"

var DescHPup: String = "+25% Max HP
HP Regen +1/sec"

var DescSTAup: String = "+25% Max Capacitor Capacitance
Capacitor Regen +25%"

var DescDmgup: String = "+25% Weapon Damage
+10% Shoot Speed"

var DescMissile: String = "Unlock the Missile launcher weapon!
Missiles explode on impact or after 1 second dealing AOE damage."

var DescSpray: String = "Unlock the Spray&Pray weapon!
S&P shoots bullets very fast but can be a little inaccurate."

# Called when the node enters the scene tree for the first time.
func _ready():
	$LogicUnlock.desc = DescLogicUnlock
	$HealthTree/HealthUp1.desc = DescHPup
	$HealthTree/HealthUp2.desc = DescHPup
	$HealthTree/HealthUp3.desc = DescHPup
	$HealthTree/HealthUp4.desc = DescHPup
	$StaTree/StaUp1.desc = DescSTAup
	$StaTree/StaUp2.desc = DescSTAup
	$StaTree/StaUp3.desc = DescSTAup
	$StaTree/StaUp4.desc = DescSTAup
	$DmgTree/DmgUp1.desc = DescDmgup
	$DmgTree/DmgUp2.desc = DescDmgup
	$DmgTree/DmgUp3.desc = DescDmgup
	$DmgTree/DmgUp4.desc = DescDmgup
	$WeaponMissileTree/MissileUp1.desc = DescMissile
	$SprayTree/SprayUp1.desc = DescSpray
	
	$LogicUnlock.costs = CostsLogicUnlock
	$HealthTree/HealthUp1.costs = CostsHealthUp[0]
	$HealthTree/HealthUp2.costs = CostsHealthUp[1]
	$HealthTree/HealthUp3.costs = CostsHealthUp[2]
	$HealthTree/HealthUp4.costs = CostsHealthUp[3]
	$StaTree/StaUp1.costs = CostsStaUp[0]
	$StaTree/StaUp2.costs = CostsStaUp[1]
	$StaTree/StaUp3.costs = CostsStaUp[2]
	$StaTree/StaUp4.costs = CostsStaUp[3]
	$DmgTree/DmgUp1.costs = CostsDmgUp[0]
	$DmgTree/DmgUp2.costs = CostsDmgUp[1]
	$DmgTree/DmgUp3.costs = CostsDmgUp[2]
	$DmgTree/DmgUp4.costs = CostsDmgUp[3]
	$WeaponMissileTree/MissileUp1.costs = CostsMissile
	$SprayTree/SprayUp1.costs = CostsSpray

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
