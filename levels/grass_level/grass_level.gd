extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_on_chunk_changed(chunk_id):
	print("Player is in chunk ", chunk_id)
	$TileMapLayer.load_near_chunks(chunk_id.x, chunk_id.y)
	$TileMapLayer.unload_far_chunks(chunk_id.x, chunk_id.y)
