extends Camera2D

#var default_cursor = preload("res://assets/cursors/target_round_b.png")
#var mining_cursor = preload("res://assets/cursors/tool_pickaxe.png")
# Called when the node enters the scene tree for the first time.

var interectinfo

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#func _physics_process(delta):
	#var pp = PhysicsPointQueryParameters2D.new()
	#pp.collide_with_areas = true  
	#pp.position = get_global_mouse_position()
	#
	#if get_world_2d().direct_space_state.intersect_point(pp, 1):
		#print("HIT")
		#interectinfo = get_world_2d().direct_space_state.intersect_point(pp, 1)
		#print(interectinfo)
		#print(str(interectinfo[0]["collider"]).left(8))
		#if str(interectinfo[0]["collider"]).left(8) == "resource":
			#Input.set_custom_mouse_cursor(mining_cursor,Input.CURSOR_ARROW,Vector2(32,32))
		#else:
			#Input.set_custom_mouse_cursor(default_cursor,Input.CURSOR_ARROW,Vector2(32,32))
	#else:
		#Input.set_custom_mouse_cursor(default_cursor,Input.CURSOR_ARROW,Vector2(32,32))
	
