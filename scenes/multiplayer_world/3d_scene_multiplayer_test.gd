extends Spatial

onready var player1_pos = $Player1Pos
onready var player2_pos = $Player2Pos

# Called when the node enters the scene tree for the first time.
func _ready():
	var player1 = preload("res://entities/client/Player+UI.tscn").instance()
	print("Player 1:",player1.player)
	player1.set_name(str(get_tree().get_network_unique_id()))
	player1.set_network_master(get_tree().get_network_unique_id())
	player1.global_transform= player1_pos.global_transform
	add_child(player1)
	
	var player2 = preload("res://entities/client/Player+UI.tscn").instance()
	player2.set_name(str(GameManager.player2_id))
	player2.set_network_master(GameManager.player2_id)
	player2.global_transform= player2_pos.global_transform
	add_child(player2)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
