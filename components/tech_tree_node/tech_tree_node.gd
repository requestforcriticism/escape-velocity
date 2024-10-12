extends AnimatedSprite2D

class_name TechTreeNode

signal on_purchase

enum TECH_TREE_STATE {LOCKED, UNLOCKED, PURCHASED}

@export var state : TECH_TREE_STATE = TECH_TREE_STATE.LOCKED
@export var depends_on_nodes : Array[TechTreeNode] = []
@export var depended_by_lines : Array[TechTreeLine] = []
@export var upgrade_key : String = "default"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	state = load_progress()
	
	if state == TECH_TREE_STATE.LOCKED:
		for dep in depends_on_nodes:
			dep.connect("on_purchase", _on_dep_purchased)
		lock_lines()
		play("locked")
	elif state == TECH_TREE_STATE.UNLOCKED:
		lock_lines()
		play("unlocked")
	elif  state == TECH_TREE_STATE.PURCHASED:
		unlock_lines()
		play("purchased")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_dep_purchased():
	if state != TECH_TREE_STATE.LOCKED:
		return
		
	var is_unlocked = true
	for dep in depends_on_nodes:
		if dep.state != TECH_TREE_STATE.PURCHASED:
			is_unlocked = false
		
	if is_unlocked:
		state = TECH_TREE_STATE.UNLOCKED
		play("unlocked")
		save_progress()

func _on_purchase():
	if state == TECH_TREE_STATE.UNLOCKED:
		if true:# TODO check if resources are availible to spend
			state = TECH_TREE_STATE.PURCHASED
			unlock_lines()
			on_purchase.emit()
			play("purchased")
			save_progress()

func lock_lines():
	for ln in depended_by_lines:
		ln.lock_line()
		
func unlock_lines():
	for ln in depended_by_lines:
		ln.unlock_line()

func load_progress():
	return Save.get_value(1, upgrade_key, state)

func save_progress():
	Save.set_value(1, upgrade_key, state)

func _on_upgrade_click(viewport, event, shape_idx):
	print("clicked ", upgrade_key, " - ", state)
	if true: # TODO test for mouse event 
		_on_purchase()
