extends KinematicBody

export(float) var GRAVITY = 9.8
export(float) var MAX_FALL_SPEED = 30
const MAX_SPEED = 50
const ATTRACT_DIST= 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velo= Vector3()
var item_name
var item_data
var player = null
var being_picked_up = false
# Called when the node enters the scene tree for the first time.
func _ready():
	item_name= "Ruby Shard"
	item_data={"Type": "Small Stack","Item Name": item_name,"Statuses":[{"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]}
	pass # Replace with function body.

func _physics_process(delta):
	if !being_picked_up:
		velo = velo.move_toward(Vector3(0,-MAX_FALL_SPEED,0),GRAVITY*delta)
	else:
		var direction = global_transform.origin.direction_to(player.global_transform.origin)
		velo = velo.move_toward(direction*MAX_SPEED,GRAVITY*delta)
		
		var distance= global_transform.origin.distance_squared_to(player.global_transform.origin)
		if distance<ATTRACT_DIST*ATTRACT_DIST:
			PlayerInventory.add_item(item_name,item_data)
			queue_free()
	velo = move_and_slide(velo,Vector3.UP)

func _process(delta):
	var camera_pos = get_viewport().get_camera().global_transform.origin
	camera_pos.y = 0
	$Sprite3D.look_at(camera_pos, Vector3(0, 1, 0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func pick_up_item(body):
	player=body
	being_picked_up=true
