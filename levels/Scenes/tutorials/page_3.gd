extends TextureRect

@export var playerBullet : PackedScene
@export var oilresource : PackedScene

var shootRdy:bool = true
var spawn_left:bool
var spawn_right:bool
var new_oil_left
var new_oil_right
var i = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_left = true
	spawn_right = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if shootRdy:
			var new_bullet = playerBullet.instantiate()
			new_bullet.rotation = 0
			new_bullet.damage = 5
			new_bullet.scale = Vector2(4,4)
			new_bullet.position = $Marker2D.position
			new_bullet.direction = Vector2(1,0)
			add_child(new_bullet)
			shootRdy = false
			
	if spawn_left:
		new_oil_left = oilresource.instantiate()
		new_oil_left.position = Vector2(700,530)
		new_oil_left.is_attacking = false
		new_oil_left.scale = Vector2(4,4)
		add_child(new_oil_left)
		spawn_left = false
	
	if spawn_right:
		new_oil_right = oilresource.instantiate()
		new_oil_right.position = Vector2(1275,530)
		new_oil_right.scale = Vector2(4,4)
		new_oil_right.max_drops = 5
		add_child(new_oil_right)
		new_oil_right.take_damage(100)
		spawn_right = false
		
	
	if new_oil_left.currentHealth <= 0:
		reset_res_left()
	

func _on_shoot_timer_timeout() -> void:
	shootRdy = true

func reset_res_left():
	await get_tree().create_timer(1.0).timeout
	new_oil_left.queue_free()
	new_oil_left.hide()
	spawn_left = true


func _on_timergather_timeout() -> void:
	new_oil_right.spawn_collectable()
	i += 1
	if i == 5:
		await get_tree().create_timer(1.0).timeout
		new_oil_right.queue_free()
		new_oil_right.hide()
		spawn_right = true
		i=0
	#var event_lmb = InputEventMouseButton.new()
	#event_lmb.position = Vector2(1350,530)