extends TileMapLayer

@export var tile_size = 32
@export var chunk_size = 32
@export var render_distance = 1

@export var chunk_decorator : PackedScene

var loaded_chunks = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_chunk_loaded(x, y):
	var bottom_tile_x = x * chunk_size
	var bottom_tile_y = y * chunk_size
	return get_cell_atlas_coords(Vector2(bottom_tile_x, bottom_tile_y)) != Vector2i(-1, -1)

func load_chunk(x, y):
	print("loading chunk " ,x, " ", y)
	var bottom_tile_x = x * chunk_size
	var bottom_tile_y = y * chunk_size
	var top_tile_x = bottom_tile_x + chunk_size
	var top_tile_y = bottom_tile_y + chunk_size
	var changed_cells = []
	for i in range(bottom_tile_x, top_tile_x):
		for j in range(bottom_tile_y, top_tile_y):
			#changed_cells.push_back(Vector2(i,j))
			set_cell(Vector2(i, j), 2, Vector2(0,0))
	#set_cells_terrain_connect(changed_cells, 0, 0, false)
	loaded_chunks.push_front(Vector2(x, y))
	$ChunkDecorator.decorate_chunk(x, y)

func unload_far_chunks(x, y):
	var safe_chunks = []
	for i in range(0, loaded_chunks.size()):
		var loaded_chunk = loaded_chunks[i]
		var is_in_range_x = (loaded_chunk.x <= x + render_distance) and (loaded_chunk.x >= x - render_distance)
		var is_in_range_y = (loaded_chunk.y <= y + render_distance) and (loaded_chunk.y >= y - render_distance)
		if !is_in_range_x or !is_in_range_y:
			unload_chunk(loaded_chunk.x, loaded_chunk.y)
		else:
			safe_chunks.push_back(loaded_chunk)
	loaded_chunks = safe_chunks
		
func load_near_chunks(x, y):
	for i in range(x-render_distance, x+render_distance):
		for j in range(y-render_distance, y+render_distance):
			load_chunk(i, j)

func unload_chunk(x, y):
	print("clearing chunk " ,x, " ", y)
	var bottom_tile_x = x * chunk_size
	var bottom_tile_y = y * chunk_size
	var top_tile_x = bottom_tile_x + chunk_size
	var top_tile_y = bottom_tile_y + chunk_size
	for i in range(bottom_tile_x, top_tile_x):
		for j in range(bottom_tile_y, top_tile_y):
			set_cell(Vector2(i, j), -1, Vector2(-1,-1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
