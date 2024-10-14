extends StaticBody2D

@export var player : Node2D
@export var collectable_scn : PackedScene
@export var monster1 : PackedScene
@export var monster2 : PackedScene
@export var max_drops = 2
var dropped = 0

enum TERMINAL_STATE {PASSIVE, ACTIVE, DEAD}

var state = TERMINAL_STATE.PASSIVE

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("alive")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var spawned_monsters = 0
var killed_monsters = 0
func _on_spawn_area_body_entered(body):
	if "player_tag" in body and state == TERMINAL_STATE.PASSIVE:
		state = TERMINAL_STATE.ACTIVE
		$AnimatedSprite2D.play("angry")
		var new_monster = monster1.instantiate()
		new_monster.connect("on_die", on_monster_die)
		add_child(new_monster)
		
		new_monster = monster1.instantiate()
		new_monster.connect("on_die", on_monster_die)
		add_child(new_monster)
		
		new_monster = monster1.instantiate()
		new_monster.connect("on_die", on_monster_die)
		add_child(new_monster)
		
		new_monster = monster1.instantiate()
		new_monster.connect("on_die", on_monster_die)
		add_child(new_monster)
		spawned_monsters += 4
		#on_die()

func on_monster_die():
	killed_monsters += 1
	if killed_monsters >= spawned_monsters:
		on_die()

func on_die():
	state = TERMINAL_STATE.DEAD
	$AnimatedSprite2D.play("dead")
	if dropped < max_drops:
		var new_drop= collectable_scn.instantiate()
		new_drop.type = "COM"
		# drop in a random dir along resource
		var drop_dest = Vector2.RIGHT.rotated(randf_range(0, 2*PI)).normalized() * 32
		new_drop.drift(drop_dest)
		#new_drop.set_collision_layer_value(4, false)
		add_child(new_drop)
		dropped += 1
