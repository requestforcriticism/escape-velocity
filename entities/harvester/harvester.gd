extends Area2D

enum DRONE_STATE { SEARCHING, MINING, CARRYING, RETURNING }

@export_group("Node References")
@export var player : Node
@export var target : Node
@export var ship : Node

@export_group("Drone Speeds")
@export var carry_speed = 0.5
@export var search_speed = 1
@export var return_speed = 2

@export var search_dest = Vector2.ZERO

var state
var minable_instance


# Called when the node enters the scene tree for the first time.
func _ready():
	state = DRONE_STATE.SEARCHING
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == DRONE_STATE.RETURNING:
		position = position.lerp(player.position, delta * return_speed)
	elif state == DRONE_STATE.CARRYING:
		position = position.lerp(ship.position, delta * carry_speed)
	elif state == DRONE_STATE.SEARCHING and target != null:
		position = position.lerp(target.position, delta * search_speed)
	elif state == DRONE_STATE.SEARCHING:
		position = position.lerp(search_dest, delta * search_speed)
	elif state == DRONE_STATE.MINING:
		position = position.lerp(target.position, delta * search_speed)

func _on_target_deplete():
	print("taget is depleted")

func change_state(new_state):
	print("Changing state from ", state, " to ", new_state)
	if new_state == DRONE_STATE.SEARCHING and target == null:
		$AnimatedSprite2D.play("default")
		state = new_state
	elif new_state == DRONE_STATE.SEARCHING:
		$AnimatedSprite2D.play("default")
		state = new_state
	elif new_state == DRONE_STATE.MINING:
		$AnimatedSprite2D.play("mining")
		var minable = target.mine(self)
		state = new_state
		minable_instance = minable[1]
		if minable[0] <= 0: #not minable or already dead
			change_state(DRONE_STATE.RETURNING)
		else:
			$MiningTimer.wait_time = minable[0]
			$MiningTimer.start()
	elif new_state == DRONE_STATE.CARRYING:
		$AnimatedSprite2D.play("carrying")
		state = new_state
	elif new_state == DRONE_STATE.RETURNING:
		$AnimatedSprite2D.play("default")
		state = new_state

func _on_search_radius_body_entered(body):
	print(body)
	if state == DRONE_STATE.SEARCHING and target == null:
		if body != player and body != ship:
			#TODO check if body is resource type
			#make sure only on player 5 to collide with
			target = body
			change_state(DRONE_STATE.MINING)

func _on_search_timer_timeout():
	if state == DRONE_STATE.SEARCHING:
		change_state(DRONE_STATE.RETURNING)


func _on_mining_timer_timeout():
	if minable_instance != null:
		var item = minable_instance
		item.show_behind_parent = true
		#item.set_collision_layer_value(1, false)
		#item.set_collision_layer_value(2, false)
		#item.set_collision_layer_value(3, false)
		item.set_collision_layer_value(4, false)
		item.set_collision_mask_value(4, false)
		add_child(item)
	change_state(DRONE_STATE.CARRYING)

#when harvester drone goes over something
func _on_body_entered(body):
	if state == DRONE_STATE.SEARCHING and target != null and body == target:
		#drone is searching but has a target already
		change_state(DRONE_STATE.MINING)
	#elif state == DRONE_STATE.MINING:
		##drone is mining so who cares
		#pass
	elif state == DRONE_STATE.CARRYING:
		#drone is carrying, check if drone sees ship
		if body == ship:
			if minable_instance != null:
				ship.collect(minable_instance.type)
				minable_instance.queue_free()
			change_state(DRONE_STATE.SEARCHING)
	elif state == DRONE_STATE.RETURNING:
		if body == player:
			queue_free()
		
	print("Drone found ", body)
	if body == player:
		print("matched player ", state)
	pass # Replace with function body.
