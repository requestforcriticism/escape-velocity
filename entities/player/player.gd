extends CharacterBody2D

signal on_chunk_changed

@export var speed:int = 30000
@export var tile_size = 32
@export var chunk_size = 32

var current_chunk = null

func pos_to_chunk(x, y):
	var tile_x = floor(x / tile_size)
	var tile_y = floor(y / tile_size)
	var chunk_x = floor(tile_x / chunk_size)
	var chunk_y = floor(tile_y / chunk_size)
	return Vector2(chunk_x, chunk_y)

func _ready():
	current_chunk = pos_to_chunk(position.x, position.y)
	on_chunk_changed.emit(current_chunk)

func _process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed * delta
	move_and_slide()
	
	var chunk_id = pos_to_chunk(position.x, position.y)
	
	if current_chunk.x != chunk_id.x || current_chunk.y != chunk_id.y:
		current_chunk = chunk_id
		on_chunk_changed.emit(current_chunk)

	#fsd
	#print("Pos X: ", snapped(position.x, 0.1), 
		#"\tY: ", snapped(position.y, 0.1), 
		#"\tTx: ", snapped(position.x, 1) / tile_size,
		#"\tTy: ", snapped(position.y, 1) / tile_size,
		#"\tCx: ", chunk_id.x,
		#"\tCy: ", chunk_id.y)
