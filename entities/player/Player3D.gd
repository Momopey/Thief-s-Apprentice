extends KinematicBody

var ChestInteractiveClass = preload("res://entities/chests/ChestInteractive.gd")
var ChestInteractive3DClass = preload("res://entities/chests/ChestInteractive3D.gd")
export(NodePath) var UI_path;
var user_interface

export(float) var MOVE_SPEED = 12
export(float) var MOVE_ACC =20
export(float) var JUMP_FORCE = 30
export(float) var GRAVITY = 0.98
export(float) var MAX_FALL_SPEED = 30
export(float) var H_LOOK_SENS = 1
export(float) var V_LOOK_SENS = 1

onready var cam = $CamBase
onready var anim = $pickpocket/AnimationPlayer

var move_vel = 0;
var y_velo = 0
func _ready():
	PlayerInventory.player = self
	user_interface = get_node(UI_path)
	anim.get_animation("Armature|Walk").set_loop(true)
	
func _input(event):
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y*V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x,-90,90)
		rotation_degrees.y -= event.relative.x*H_LOOK_SENS
	if event.is_action_pressed("interact"):
		for interactive in interactives:
			if interactive is ChestInteractiveClass|| interactive is ChestInteractive3DClass:
				if !interactive.open:
					print("INTERACTED NEAR CHEST")
					var chest_inventory_ui=interactive.inventory_ui_scene.instance()
#					GameManager.user_interface.set_visible(true)
					interactive.inventory_ui=chest_inventory_ui
	#				print(interactive.inventory_source())
					chest_inventory_ui.inventory=interactive.inventory_source()
	#				chest_inventory_ui.user_interface = user_interface
					user_interface.show_inventory_ui(chest_inventory_ui,interactive)
				else: 
					user_interface.hide_inventory_ui(interactive.inventory_ui,interactive)
	
func _physics_process(delta):
	var move_vec:= Vector3()
	move_vec.z += Input.get_action_strength("move_backwards")-Input.get_action_strength("move_forwards")
	move_vec.x += Input.get_action_strength("move_right")- Input.get_action_strength("move_left")
	if move_vec.length()>0:
		move_vel+=MOVE_ACC*delta
	else:
		move_vel-=MOVE_ACC*delta
	move_vel= clamp(move_vel,0,MOVE_SPEED)
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0,1,0),rotation.y)
	move_vec*= move_vel
	move_vec.y = y_velo
#	$pickpocket.rotation.y =- move_vec.angle_to(get_global_transform().basis.z)	
	if Vector3(move_vec.x,0,move_vec.z).length()>0.05:
		$pickpocket.look_at(transform.origin+Vector3(move_vec.x,0,move_vec.z),Vector3(0,1,0))
	move_and_slide(move_vec,Vector3(0,1,0))
	
	
	var grounded = is_on_floor()
	y_velo-=GRAVITY
	var just_jumped = false
	if grounded:
		if Input.is_action_just_pressed("jump"):
			just_jumped=true
			y_velo = JUMP_FORCE
		if y_velo<=0:
			y_velo=-0.1
		if y_velo <-MAX_FALL_SPEED:
			y_velo= -MAX_FALL_SPEED
	
	if just_jumped:
#		play jump anim
		print("play jump anim")
	elif grounded:
		if move_vec.length()==0:
#			play idle
			print("play idle anim")
		else:
			play_anim("Armature|Walk")
			anim.playback_speed = move_vec.length()*0.65
		
func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

var interactives = []
func add_interactive(interactive):
	interactives.append(interactive)
	print("INTERACTIVE INRANGE")
	
func remove_interactive(interactive):
	if interactives.has(interactive):
		interactives.erase(interactive)
		if interactive is ChestInteractiveClass || interactive is ChestInteractive3DClass:
			if interactive.open: 
				user_interface.hide_inventory_ui(interactive.inventory_ui,interactive)
func get_inventory():
	return PlayerInventory
		


var items_in_range= {}
func _on_PickupZone_body_entered(body):
	items_in_range[body]=body
	
	pass # Replace with function body.

func _on_PickupZone_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)
	pass # Replace with function body.
func _process(delta):
	if items_in_range.size()>0:
		var pickup_item=items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		items_in_range.erase(pickup_item)
