extends TextureRect

@export var oilresource : PackedScene

var spawn:bool
var new_oil_left
var new_oil_right
var i = 0

func _ready() -> void:
	spawn = true

func _process(delta: float) -> void:
	if spawn:
		new_oil_left = oilresource.instantiate()
		new_oil_right = oilresource.instantiate()
		new_oil_left.position = Vector2(210,550)
		new_oil_right.position = Vector2(585,550)
		new_oil_left.scale = Vector2(4,4)
		new_oil_right.scale = Vector2(4,4)
		new_oil_left.max_drops = 2
		new_oil_right.max_drops = 10
		add_child(new_oil_left)
		add_child(new_oil_right)
		new_oil_left.take_damage(100)
		new_oil_right.take_damage(100)
		spawn= false
		
	#if !visible && new_oil_left != null && new_oil_right != null:
		#new_oil_left.queue_free()
		#new_oil_left.hide()
		#new_oil_right.queue_free()
		#new_oil_right.hide()
		#i=0

func _on_timergather_timeout() -> void:
	if visible:
		i += 1
		if i <=2:
			new_oil_left.spawn_collectable()
		if i<= 10:
			new_oil_right.spawn_collectable()
		if i == 10:
			await get_tree().create_timer(2.0).timeout
			new_oil_left.queue_free()
			new_oil_left.hide()
			new_oil_right.queue_free()
			new_oil_right.hide()
			spawn = true
			i=0
