extends Node2D

@export var roof_layer : TileMapLayer:
	set(value):
		$OutdoorLayer/ChunkDecorator.roof_layer = value
	get():
		return $OutdoorLayer/ChunkDecorator.roof_layer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_on_chunk_changed(chunk_id):
	#print("Player is in chunk ", chunk_id)
	$OutdoorLayer.load_near_chunks(chunk_id.x, chunk_id.y)
	$OutdoorLayer.unload_far_chunks(chunk_id.x, chunk_id.y)
