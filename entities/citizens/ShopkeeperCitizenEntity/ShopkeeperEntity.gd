extends KinematicBody
var path = []
var path_node := 0
export(float) var MOVE_SPEED = 10
export(NodePath) var timer_path;
var timer:Timer

onready var nav:Navigation = get_parent()
var player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
#export(NodePath) var player_client_path
func is_server():
	if get_tree():
		if get_tree().network_peer:
			return get_tree().is_network_server()
	return true

var player_client
func _ready():
	if is_server():
		assert(nav is Navigation)
		timer = get_node(timer_path)
	#	player_client = GameManager.clients[0]
		assert(timer is Timer)
	pass # Replace with function body.

func _physics_process(delta):
	if is_server():
		player_client = GameManager.clients[0]
		for client in GameManager.clients:
			if (client.player.global_transform.origin -global_transform.origin).length()<(player_client.player.global_transform.origin -global_transform.origin).length():
				player_client= client
		if path_node<path.size():
			var direction = (path[path_node]-global_transform.origin)
			if direction.length()<1:
				path_node+=1
			else:
				move_and_slide(direction.normalized()*MOVE_SPEED,Vector3(0,1,0))
		else:
			move_to(player_client.player.global_transform.origin)
		if get_tree().network_peer:
			rpc_unreliable("_set_transform",global_transform)
remote func _set_transform(glob_trans):
	global_transform= glob_trans

var count := 0 
func move_to(target_pos:Vector3):
	print("MOVING:",count)
	count+=1
	path = nav.get_simple_path(global_transform.origin,target_pos)
	path_node = 0

func _on_Timer_timeout():
	move_to(player_client.player.global_transform.origin)
	var dist = (global_transform.origin-player_client.player.global_transform.origin).length()
	if dist>10:
		timer.wait_time= 5
	elif dist>5:
		timer.wait_time = 2
	else:
		timer.wait_time = 0.5
#	timer.
	pass # Replace with function body.
