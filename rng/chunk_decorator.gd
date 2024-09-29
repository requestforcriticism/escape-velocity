extends Node

@export var seed = 6758493012
@export var dmz_x = 2
@export var dmz_y = 2
@export var tile_size = 32
@export var chunk_size = 32
@export var tilemap : TileMapLayer

@export var demo_resource : PackedScene
@export var base_resource : PackedScene

@export var grass_tiles : TileSet
@export var rock_tiles : TileSet
@export var sand_tiles : TileSet

var loaded_resources = {}
var biome = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	biome = 1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_chunk_seed(x, y):
	var chunk_mask = (x * 100000) + y #offset x and y to reduce repeats
	return seed ^ chunk_mask # add it in, now the seed is indexable by chunk

func get_chunk_meta(x , y):
	var rng = get_chunk_generator(x, y)
	
	var meta = {
		"biome" : biome,
		"is_ruin" : rng.randi_range(1, 10) == 10
	}
	return meta

func get_chunk_generator(x, y):
	var chunk_seed = get_chunk_seed(x, y)
	print("Chunk seed is ", chunk_seed)
	var rng =  RandomNumberGenerator.new()
	rng.seed = chunk_seed
	return rng
	
func decorate_chunk(x, y):
	var rng = get_chunk_generator(x, y)
	var meta = get_chunk_meta(x, y)
	print("Decorating chunk (", x, ", ", y, ")")
	#roll tile decoration
	for i in range(1,rng.randi_range(50, 100)):
		var x_atlas = rng.randi_range(1,3)
		var y_atlas = rng.randi_range(1,3)
		var x_offset = rng.randi_range(0,30)
		var y_offset = rng.randi_range(0,30)
		tilemap.set_cell(Vector2((x * chunk_size) + x_offset, (y * chunk_size) + y_offset), meta.biome, Vector2i(x_atlas, y_atlas))
		
	
	spawn_feature(demo_resource, (x * chunk_size) + rng.randi_range(0,32), (y * chunk_size) + rng.randi_range(0,32),x ,y)
	
	spawn_feature(base_resource, (x * chunk_size) + rng.randi_range(0,32), (y * chunk_size) + rng.randi_range(0,32),x, y)
	
	#roll num res
	#roll normals
	#roll rares
	
func coord_to_key(x, y):
	return str(x)+","+str(y)
	
func can_spawn(tx, ty, cx, cy):
	var chunk_key = coord_to_key(cx, cy)
	if !loaded_resources.has(chunk_key):
		loaded_resources[chunk_key] = {}
	
	var tile_key = coord_to_key(tx, ty)
	if !loaded_resources[chunk_key].has(tile_key):
		loaded_resources[chunk_key][tile_key] = {}
		return true
	else:
		return false
	
func unload_resources(cx, cy):
	var chunk_key = coord_to_key(cx, cy)
	if !loaded_resources.has(chunk_key):
		return
	for i in loaded_resources[chunk_key]:
		if loaded_resources[chunk_key][i] != null:
			loaded_resources[chunk_key][i].queue_free()
	loaded_resources.erase(chunk_key)
	
func spawn_feature(feature:PackedScene, tx, ty, chunk_x, chunk_y):
	if !can_spawn(tx, ty, chunk_x, chunk_y):
		return
	
	var new_feature = feature.instantiate()
	new_feature.position.x = tx * tile_size
	new_feature.position.y = ty * tile_size
	tilemap.add_child(new_feature)
	
	loaded_resources[coord_to_key(chunk_x, chunk_y)][coord_to_key(tx, ty)] = new_feature
	#print(loaded_resources)
	#loaded_resources[chunk_key] = new_feature
	#print(loaded_resources[chunk_key])
	
func pick(rng:RandomNumberGenerator, opts:Array):
	var d_size = opts.size()
	var roll = rng.randi_range(0, d_size-1)
	return opts[roll]
