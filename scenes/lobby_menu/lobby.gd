extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var game_started := false
# Called when the node enters the scene tree for the first time.
func _ready():
	$IPTextEdit.text = "127.0.0.1"
	get_tree().connect("network_peer_connected",self,"_player_connected")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonHost_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_server(25565,2)
	get_tree().set_network_peer(net)
	print("hosting")


func _on_ButtonJoin_pressed():
	var net = NetworkedMultiplayerENet.new()
	
#	"127.0.0.1"
	var err = net.create_client($IPTextEdit.text,25565)
	if err == OK:
		get_tree().set_network_peer(net)
		print("joining")
	else:
		$IPTextEdit.text = "Address error: "+ str(err)+"  -  "
	
func _player_connected(id):
	if !game_started:
		GameManager.player2_id = id 
		var Game = preload("res://scenes/multiplayer_world/3d_scene_multiplayer_test.tscn").instance()
		get_tree().get_root().add_child(Game)
		hide()
	pass

func _on_ButtonSingleplayer_pressed():
	var Game = preload("res://scenes/main/3d_scene_test.tscn").instance()
	get_tree().get_root().add_child(Game)
	hide()
	pass # Replace with function body.
