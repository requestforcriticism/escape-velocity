extends Node

@export var seed = 6758493012
@export var dmz_x = 2
@export var dmz_y = 2
@export var tile_size = 32
@export var chunk_size = 32
@export var tilemap : TileMapLayer
@export var struct_layer : TileMapLayer
@export var roof_layer : TileMapLayer

@export var demo_resource : PackedScene
@export var base_resource : PackedScene
@export var ore_vein : PackedScene
@export var water_source : PackedScene
@export var oil_well : PackedScene

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
		"is_ruin" : rng.randi_range(1, 2) == 1
	}
	return meta

func get_chunk_generator(x, y):
	var chunk_seed = get_chunk_seed(x, y)
#	print("Chunk seed is ", chunk_seed)
	var rng =  RandomNumberGenerator.new()
	rng.seed = chunk_seed
	return rng
	
#var ruin_corners = 
var ruin_floor = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(3,0), Vector2i(4,0), Vector2i(5,0), Vector2i(6,0), Vector2i(7,0),Vector2i(5,2),Vector2i(6,2),Vector2i(5,3),Vector2i(6,3) ]
var ruin_roof = [Vector2(1,2), Vector2(2,2),Vector2(1,3), Vector2(2,3)]
func generate_ruin(x , y):
	var setback = 10
	var rng = get_chunk_generator(x, y)
	var bound_left = x*chunk_size + setback
	var bound_right = x*chunk_size+chunk_size-setback
	var bound_top = y*chunk_size + setback
	var bound_bottom = y*chunk_size+chunk_size-setback
	
	#fill tiles
	for i in range(bound_left, bound_right+1):
		for j in range(bound_top, bound_bottom+1):
			var floor_tile = ruin_floor[rng.randi_range(0, 11)]
			var roof_tile = ruin_roof[rng.randi_range(0, 3)]
			#set edges or fill floor tile
			if i == bound_left:
				struct_layer.set_cell(Vector2(i, j), 4, Vector2i(4,3))
				roof_layer.set_cell(Vector2(i, j), 4, Vector2i(0,2))
			elif i == bound_right:
				struct_layer.set_cell(Vector2(i, j), 4, Vector2i(7,3))
				roof_layer.set_cell(Vector2(i, j), 4, Vector2i(3,2))
			elif j == bound_top:
				struct_layer.set_cell(Vector2(i, j), 4, Vector2i(6,1))
				roof_layer.set_cell(Vector2(i, j), 4, Vector2i(2,1))
			elif j == bound_bottom:
				struct_layer.set_cell(Vector2(i, j), 4, Vector2i(5,4))
				roof_layer.set_cell(Vector2(i, j), 4, Vector2i(1,4))
			else:			
				struct_layer.set_cell(Vector2(i, j), 4, floor_tile, rng.randi_range(0, 3))
				roof_layer.set_cell(Vector2(i, j), 4, roof_tile, rng.randi_range(0, 3))
				
	#then set corners
	struct_layer.set_cell(Vector2(bound_left, bound_top), 4, Vector2i(4,1))
	struct_layer.set_cell(Vector2(bound_left, bound_bottom), 4, Vector2i(4,4))
	struct_layer.set_cell(Vector2(bound_right, bound_top), 4, Vector2i(7,1))
	struct_layer.set_cell(Vector2(bound_right, bound_bottom), 4, Vector2i(7,4))
	roof_layer.set_cell(Vector2(bound_left, bound_top), 4, Vector2i(0,1))
	roof_layer.set_cell(Vector2(bound_left, bound_bottom), 4, Vector2i(0,4))
	roof_layer.set_cell(Vector2(bound_right, bound_top), 4, Vector2i(3,1))
	roof_layer.set_cell(Vector2(bound_right, bound_bottom), 4, Vector2i(3,4))
	
	#pick side to open
	var side = rng.randi_range(0, 4)
#	print("side is ", side)
	if side == 0: #open top
	#	print("add ing top, side is ", side)
		roof_layer.set_cell(Vector2i((bound_left+bound_right)/2,bound_top), 1, Vector2i(-1,-1))
		roof_layer.set_cell(Vector2i(((bound_left+bound_right)/2)+1,bound_top), 1, Vector2i(-1,-1))
		struct_layer.set_cell(Vector2i((bound_left+bound_right)/2,bound_top), 4, ruin_floor[0])
		struct_layer.set_cell(Vector2i(((bound_left+bound_right)/2)+1,bound_top), 4, ruin_floor[0])
	elif side == 1: #open bottom
		roof_layer.set_cell(Vector2i((bound_left+bound_right)/2,bound_bottom), 1, Vector2i(-1,-1))
		roof_layer.set_cell(Vector2i(((bound_left+bound_right)/2)+1,bound_bottom), 1, Vector2i(-1,-1))
		struct_layer.set_cell(Vector2i((bound_left+bound_right)/2,bound_bottom), 4, ruin_floor[0])
		struct_layer.set_cell(Vector2i(((bound_left+bound_right)/2)+1,bound_bottom), 4, ruin_floor[0])
	elif side == 2: #open left
		roof_layer.set_cell(Vector2i(bound_left, (bound_top+bound_bottom)/2), 1, Vector2i(-1,-1))
		roof_layer.set_cell(Vector2i(bound_left, ((bound_top+bound_bottom)/2)+1), 1, Vector2i(-1,-1))
		struct_layer.set_cell(Vector2i(bound_left,(bound_top+bound_bottom)/2), 4, ruin_floor[0])
		struct_layer.set_cell(Vector2i(bound_left,((bound_top+bound_bottom)/2)+1), 4, ruin_floor[0])
	else: #open right
		roof_layer.set_cell(Vector2i(bound_right, (bound_top+bound_bottom)/2), 1, Vector2i(-1,-1))
		roof_layer.set_cell(Vector2i(bound_right, ((bound_top+bound_bottom)/2)+1), 1, Vector2i(-1,-1))
		struct_layer.set_cell(Vector2i(bound_right,(bound_top+bound_bottom)/2), 4, ruin_floor[0])
		struct_layer.set_cell(Vector2i(bound_right,((bound_top+bound_bottom)/2)+1), 4, ruin_floor[0])
	

func decorate_chunk(x, y):
	var rng = get_chunk_generator(x, y)
	var meta = get_chunk_meta(x, y)
#	print("Decorating chunk (", x, ", ", y, ")")
	
	#roll tile decoration
	for i in range(1,rng.randi_range(50, 100)):
		var x_atlas = rng.randi_range(1,3)
		var y_atlas = rng.randi_range(1,3)
		var x_offset = rng.randi_range(0,30)
		var y_offset = rng.randi_range(0,30)
		tilemap.set_cell(Vector2((x * chunk_size) + x_offset, (y * chunk_size) + y_offset), meta.biome, Vector2i(x_atlas, y_atlas))
		
	if meta.is_ruin:
		generate_ruin(x, y)
	else:
		spawn_feature(base_resource, (x * chunk_size) + rng.randi_range(0,32), (y * chunk_size) + rng.randi_range(0,32),x ,y)
		spawn_feature(ore_vein, (x * chunk_size) + rng.randi_range(0,32), (y * chunk_size) + rng.randi_range(0,32),x, y)
		spawn_feature(water_source, (x * chunk_size) + rng.randi_range(0,32), (y * chunk_size) + rng.randi_range(0,32),x, y)
		spawn_feature(oil_well, (x * chunk_size) + rng.randi_range(0,32), (y * chunk_size) + rng.randi_range(0,32),x, y)
	
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
