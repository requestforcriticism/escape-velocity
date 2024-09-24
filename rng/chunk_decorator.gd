extends Node

@export var seed = 0
@export var dmz_x = 2
@export var dmz_y = 2
@export var tile_size = 32
@export var chunk_size = 32
@export var tilemap : TileMapLayer

func get_chunk_seed(x, y):
	var chunk_mask = (x * 100000) + y #offset x and y to reduce repeats
	return seed ^ chunk_mask # add it in, now the seed is indexable by chunk

func get_chunk_generator(x, y):
	var chunk_seed = get_chunk_seed(x, y)
	var rng =  RandomNumberGenerator.new()
	rng.set_seed(chunk_seed)
	return rng
	

	
func decorate_chunk(x, y):
	var rng = get_chunk_generator(x, y)
	print("Decorating chunk (", x, ", ", y, ")")
	#roll tile decoration
	for i in range(1,rng.randi_range(50, 100)):
		var x_atlas = rng.randi_range(1,3)
		var y_atlas = rng.randi_range(1,3)
		var x_offset = rng.randi_range(0,30)
		var y_offset = rng.randi_range(0,30)
		
		tilemap.set_cell(Vector2((x * chunk_size) + x_offset, (y * chunk_size) + y_offset), 2, Vector2i(x_atlas, y_atlas))
		
	#roll num res
	#roll normals
	#roll rares
	
func spawn_feature(feature, tx, ty):
	pass
	
func pick(rng:RandomNumberGenerator, opts:Array):
	var d_size = opts.size()
	var roll = rng.randi_range(0, d_size-1)
	return opts[roll]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
