extends AnimatedSprite2D

enum PLAYER_MOVE_STATE { IDLE, WALKING, DASHING}
enum PLAYER_ACTION_STATE { PASSIVE, SHOOTING, DOUBLE_SHOOTING,HARVESTER, MINING }

var move_state
var action_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#state = PLAYER_ANIMATE_STATE.IDLE
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if move_state == PLAYER_MOVE_STATE.IDLE && action_state == PLAYER_ACTION_STATE.PASSIVE:
		$".".play("idle")
	elif move_state == PLAYER_MOVE_STATE.IDLE && action_state == PLAYER_ACTION_STATE.SHOOTING:
		$".".play("idle_shooting")
	elif move_state == PLAYER_MOVE_STATE.IDLE && action_state == PLAYER_ACTION_STATE.DOUBLE_SHOOTING:
		$".".play("idle_double_shooting")
	elif move_state == PLAYER_MOVE_STATE.IDLE && action_state == PLAYER_ACTION_STATE.MINING:
		$".".play("idle_mining")
	elif move_state == PLAYER_MOVE_STATE.IDLE && action_state == PLAYER_ACTION_STATE.HARVESTER:
		$".".play("idle_harvester")
	elif move_state == PLAYER_MOVE_STATE.WALKING && action_state == PLAYER_ACTION_STATE.PASSIVE:
		$".".play("walking")
	elif move_state == PLAYER_MOVE_STATE.WALKING && action_state == PLAYER_ACTION_STATE.SHOOTING:
		$".".play("walking_shooting")
	elif move_state == PLAYER_MOVE_STATE.WALKING && action_state == PLAYER_ACTION_STATE.DOUBLE_SHOOTING:
		$".".play("walking_double_shooting")
	elif move_state == PLAYER_MOVE_STATE.WALKING && action_state == PLAYER_ACTION_STATE.MINING:
		$".".play("walking_mining")
	elif move_state == PLAYER_MOVE_STATE.WALKING && action_state == PLAYER_ACTION_STATE.HARVESTER:
		$".".play("walking_harvester")
	else:
		$".".play("idle")
	#elif move_state == PLAYER_MOVE_STATE.DASHING && action_state == PLAYER_ACTION_STATE.PASSIVE:
		#$".".play("dashing")
	#elif move_state == PLAYER_MOVE_STATE.DASHING && action_state == PLAYER_ACTION_STATE.SHOOTING:
		#$".".play("dashing_shooting")
	#elif move_state == PLAYER_MOVE_STATE.DASHING && action_state == PLAYER_ACTION_STATE.MINING:
		#$".".play("dashing_mining")
	#elif move_state == PLAYER_MOVE_STATE.DASHING && action_state == PLAYER_ACTION_STATE.HARVESTER:
		#$".".play("dashing_harverster")
	
	pass
	
func change_state(M_State, A_State):
	if M_State == "WALKING":
		move_state = PLAYER_MOVE_STATE.WALKING
	else:
		move_state = PLAYER_MOVE_STATE.IDLE
	
	if A_State == "SHOOTING":
		action_state = PLAYER_ACTION_STATE.SHOOTING
	elif A_State == "DOUBLE_SHOOTING":
		action_state = PLAYER_ACTION_STATE.DOUBLE_SHOOTING
	elif A_State == "HARVESTER":
		action_state = PLAYER_ACTION_STATE.HARVESTER
	elif A_State == "MINING":
		action_state = PLAYER_ACTION_STATE.MINING
	else:
		action_state = PLAYER_ACTION_STATE.PASSIVE
