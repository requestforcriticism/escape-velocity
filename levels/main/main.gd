extends Node2D

@export var tile_size = 32
@export var chunk_size = 32
@export var render_distance = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$player.chunk_size = chunk_size
	$player.tile_size = chunk_size
	$grass_level/TileMapLayer.chunk_size = chunk_size
	$grass_level/TileMapLayer.tile_size = chunk_size
	$grass_level/TileMapLayer.render_distance = render_distance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
