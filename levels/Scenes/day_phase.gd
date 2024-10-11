extends Node2D

@export var playerBullet : PackedScene
@export var collectable : PackedScene

@export var tile_size = 32
@export var chunk_size = 32
@export var render_distance = 1
@export var dayLength = 60		# in seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	$player/Camera2D.make_current()
	$player/Camera2D/PauseCanvasLayer/PauseMenu.visible = false
	$player.chunk_size = chunk_size
	$player.tile_size = chunk_size
	$grass_level/OutdoorLayer.chunk_size = chunk_size
	$grass_level/OutdoorLayer.tile_size = chunk_size
	$grass_level/OutdoorLayer.render_distance = render_distance
	start_day()
	
	var new_collectable = collectable.instantiate()
	new_collectable.type = "OIL"
	new_collectable.position = Vector2(100,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "WAT"
	new_collectable.position = Vector2(-100,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "URA"
	new_collectable.position = Vector2(50,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "IRO"
	new_collectable.position = Vector2(0,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "ORA"
	new_collectable.position = Vector2(-50,100)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "PUR"
	new_collectable.position = Vector2(-150,100)
	add_child(new_collectable)
	
	new_collectable = collectable.instantiate()
	new_collectable.type = "OIL"
	new_collectable.position = Vector2(100,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "WAT"
	new_collectable.position = Vector2(-100,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "URA"
	new_collectable.position = Vector2(50,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "IRO"
	new_collectable.position = Vector2(0,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "ORA"
	new_collectable.position = Vector2(-50,50)
	add_child(new_collectable)
	new_collectable = collectable.instantiate()
	new_collectable.type = "PUR"
	new_collectable.position = Vector2(-150,50)
	add_child(new_collectable)
	
	
#all the stuff to start a new day
func start_day():
	$player/Camera2D/hud.start_day(dayLength)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_player_shoot(pos,lookx,looky) -> void:
	#var new_bullet = playerBullet.instantiate()
	#var looking = Vector2(lookx,looky)
	#new_bullet.position = pos
	#new_bullet.direction = looking
	##new_bullet.velocity = looking
	#add_child(new_bullet)
