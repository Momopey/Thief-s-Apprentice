extends KinematicBody
class_name Player3D

var ChestInteractiveClass = preload("res://entities/chests/ChestInteractive.gd")
var ChestInteractive3DClass = preload("res://entities/chests/ChestInteractive3D.gd")
export(NodePath) var UI_path;
var user_interface
export(NodePath) var client_path
var client
var nav #NavMesh

export(float) var MOVE_SPEED = 12
export(float) var MOVE_ACC =20
export(float) var JUMP_FORCE = 30
export(float) var GRAVITY = 0.98
export(float) var MAX_FALL_SPEED = 30
export(float) var H_LOOK_SENS = 1
export(float) var V_LOOK_SENS = 1
var move_vel = 0;
var y_velo = 0

onready var cam = $CamBase
onready var anim = $pickpocket/AnimationPlayer
onready var inventory= get_parent()

var dialog_name = "Player"
export(Texture) var dialog_speaker_texture

export(NodePath) var nav_target_path
var nav_target

func _ready():
	user_interface = get_node(UI_path)
	client = get_node(client_path)
	nav = client.world.nav
	nav_target = get_node(nav_target_path)
	nav_target.connect_to_nav(nav)
	
	anim.get_animation("Armature|Walk").set_loop(true)
	
var interactive_ui
var dialog;
var dialog_source;

func _input(event):
	if client.is_client():
		if event is InputEventMouseMotion:
			cam.rotation_degrees.x -= event.relative.y*V_LOOK_SENS
			cam.rotation_degrees.x = clamp(cam.rotation_degrees.x,-90,90)
			rotation_degrees.y -= event.relative.x*H_LOOK_SENS
#		if event.is_action_pressed("interact"):
		for interactive in interactives:
			interactive.interact(event,self)
			
func _physics_process(delta):
	if client.is_client():
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
#		if (near_nav_point-global_transform.origin).length()>nav_shift_radius:
#			var new_near_nav_point =  nav.get_closest_point(global_transform.origin)
#			var new_near_nav_mesh = nav.get_closest_point_owner(global_transform.origin)
#			if (new_near_nav_mesh != near_nav_mesh) or (new_near_nav_point != near_nav_point):
#				near_nav_point = new_near_nav_point
#				near_nav_mesh  = new_near_nav_mesh
#				counttt+=1
##				print("Player SHIFTY:",counttt)
#				emit_signal("nav_point_shift",self,near_nav_point,near_nav_mesh) 

		
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
#			print("play jump anim")
			pass
		elif grounded:
			if move_vec.length()==0:
				pass
#	#			play idle
#				print("play idle anim")
			else:
				play_anim("Armature|Walk")
				anim.playback_speed = move_vec.length()*0.65
		if client.network():
			rpc_unreliable("_set_position",global_transform,$pickpocket.global_transform)
			rpc_unreliable("_set_anim",anim.current_animation,anim.playback_speed)
remote func _set_position(trans,pick_trans):
	global_transform=trans
	$pickpocket.global_transform = pick_trans
remote func _set_anim(curr_anim,cur_speed):
	anim.current_animation= curr_anim
#	anim.current_animation_position= cur_pos
	anim.playback_speed= cur_speed
func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

var interactives = []
func add_interactive(interactive):
	interactives.append(interactive)
#	print("INTERACTIVE INRANGE")
	
func remove_interactive(interactive):
	if client.is_client():
		if interactives.has(interactive):
			interactives.erase(interactive)
			if interactive is ChestInteractiveClass || interactive is ChestInteractive3DClass:
				if interactive.open: 
					user_interface.hide_inventory_ui(interactive_ui,interactive)
func get_inventory():
	return inventory
		


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
		
func test_func():
	
	print("TESt FUNC CALLED !!!! ")
