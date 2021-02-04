extends KinematicBody2D

const ACCEL = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
const ATTRACT_DIST= 10
var item_name
var item_data
var player = null
var being_picked_up = false


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	item_name= "Ruby Shard"
	item_data= {"Type": "Small Stack","Item Name": item_name,"Statuses":[{"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]}
	pass # Replace with function body.

func _physics_process(delta):
	if !being_picked_up:
		velocity = velocity.move_toward(Vector2(0,MAX_SPEED),ACCEL*delta)
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction*MAX_SPEED,ACCEL*delta)
		
		var distance= global_position.distance_squared_to(player.global_position)
		if distance<ATTRACT_DIST*ATTRACT_DIST:
			PlayerInventory.add_item(item_name,item_data)
			queue_free()
	velocity = move_and_slide(velocity,Vector2.UP)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func pick_up_item(body):
	player=body
	being_picked_up=true

