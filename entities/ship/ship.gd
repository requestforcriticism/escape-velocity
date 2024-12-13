extends StaticBody2D

@export var collectables:int
# Called when the node enters the scene tree for the first time.
@export var player : Node2D

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func collect(item, amount:int = 1):
	var current_item_count = Save.get_value(1, item, 0)
	Save.set_value(1, item, current_item_count + amount)
	#Save.save_file(1)

#when player enters, copy stuff over
func _on_area_2d_body_entered(body):
	var amountcol:bool = false
	if body == player and "colable" in body:
		for i in range(0, player.colable.size()):
			#print(player.colable[i], " ", player.colnames[i])
			if player.colable[i] != 0:
				amountcol = true
			collect(player.colnames[i], player.colable[i])
			player.colable[i] = 0
	if amountcol:
		$TextureRect.visible = true
		for i in 100:
			$TextureRect.modulate.a += -.01
			await get_tree().create_timer(.02).timeout
			
		$TextureRect.visible = false
		$TextureRect.modulate.a = 1
		
