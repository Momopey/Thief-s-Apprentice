extends KinematicBody
export(PackedScene) var dialog_scene
export(Resource) var dialog_story_resource
export(String) var dialog_title = "Plains/Battle/Slime"
var open = false
var dialog
var dialog_target

func kill_dialog_target():
	print("KILL DIALOG TARGET DONE !!!!")
	dialog_target.kill_with(null);

var dialog_name = "DR. Robotnik"
export(Texture) var dialog_speaker_texture

var path = []
var path_node := 0
export(float) var MOVE_SPEED = 10
export(NodePath) var timer_path;
var timer:Timer

onready var nav:Navigation = get_parent()


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


#class ShopkeeperAI extends CitizenAI:
#	pass
export(Array,NodePath) var chest_paths	
var chests := []
func _ready():
	ai = CitizenAI.new()
	ai.init(self,[PreventTheftShopkeeperCitizenGoal.new()])
	if is_server():
		assert(nav is Navigation)
		timer = get_node(timer_path)
	#	player_client = GameManager.clients[0]
		assert(timer is Timer)
	for chest_path in chest_paths:
		chests.append(get_node(chest_path))	
#		get_node(chest_path).connect("attention_event",self,"_bruh")
	
	pass # Replace with function body.
#func _bruh(data):
#	print("BRUH YEP")

class PreventTheftShopkeeperCitizenGoal extends CitizenGoal:
	func node_to_focus(object:Node,attention_event):
		if attention_event is AreaEnterAttentionEvent:
			if attention_event.area == ai.citizen.get_node("LocalZone"):
				print("LOCALZONE ENTERED:"+ str(attention_event.object))
				if attention_event.subject in ai.citizen.chests:
					return CitizenFocus.new().init(ai,self,object)
		if attention_event is InteractChestAttentionEvent:
			return SuspiciousSubjectShopkeeperCitizenFocus.new().init(ai,self,attention_event.actor)
		
		return null
	func focused_event_to_target(focus,attention_event): # -> CitizenTarget
		if focus is SuspiciousSubjectShopkeeperCitizenFocus:
			if focus.salience>3:
				print("bruh")
				print_stack()
				return SuspiciousSubjectShopkeeperCitizenTarget.new().init(ai,self,focus.object)
		return null
	
class SuspiciousSubjectShopkeeperCitizenFocus extends CitizenFocus:
	func on_attention_event(attention_event):
		salience+=1
		pass
		
class SuspiciousSubjectShopkeeperCitizenTarget extends CitizenTarget:
	func on_activate():
		print("NOW ACTIVE BUAHAHAH")
	var count = 0
	func on_process(delta):
		
		if (object.global_transform.origin- ai.citizen.global_transform.origin).length()<4:
			if !ai.citizen.open:
				ai.citizen.dialog_target = self
				ai.citizen.dialog = ai.citizen.dialog_scene.instance()
				ai.citizen.dialog.story_resource =ai.citizen.dialog_story_resource
				ai.citizen.dialog.story_title = ai.citizen.dialog_title
				ai.citizen.dialog.speaker = ai.citizen
				ai.citizen.dialog.player = object
				
				object.user_interface.show_dialog(ai.citizen.dialog,ai.citizen)
				
		pass
	func on_physics_process(delta):
		count+=1
		ai.citizen.targeting= true
		ai.citizen.target_loc = object.global_transform.origin
	func on_kill():
		ai.citizen.targeting= false
		print("Killed")


var ai:CitizenAI
var targeting := false
var target_loc : Vector3

func _physics_process(delta):
	if is_server():
		player_client = GameManager.clients[0]
		ai.on_physics_process(delta)
#		for client in GameManager.clients:
#			if (client.player.global_transform.origin -global_transform.origin).length()<(player_client.player.global_transform.origin -global_transform.origin).length():
#				player_client= client
#		targeting= false
#		target_loc = player_client.player.global_transform.origin
		if targeting:
			if path_node<path.size():
				var direction = (path[path_node]-global_transform.origin)
				if direction.length()<1:
					path_node+=1
				else:
					move_and_slide(direction.normalized()*MOVE_SPEED,Vector3(0,1,0))
			else:
				move_to(target_loc)
		if get_tree().network_peer:
			rpc_unreliable("_set_transform",global_transform)
remote func _set_transform(glob_trans):
	global_transform= glob_trans

var count := 0 
func move_to(target_pos:Vector3):
#	print("MOVING:",count)
	count+=1
	path = nav.get_simple_path(global_transform.origin,target_pos)
	path_node = 0

func _on_Timer_timeout():
	if targeting:
		move_to(player_client.player.global_transform.origin)
		var dist = (global_transform.origin-target_loc).length()
		if dist>10:
			timer.wait_time= 5
		elif dist>5:
			timer.wait_time = 2
		else:
			timer.wait_time = 0.5
	#	timer.
		pass # Replace with function body.
	
#var points :=  []
func _process(delta):
	ai.on_process(delta)
	var ig = $attentions/attention_line
	ig.clear()
	for focus in ai.focuses:
		ig.begin(Mesh.PRIMITIVE_LINE_STRIP)
		var points = [transform.origin,focus.object.global_transform.origin]
		for p in points:
			ig.add_vertex(p)
		ig.end()


func _on_PeriferalZone_body_entered(body):
	if ai:
		ai.on_object_attend(body,AreaEnterAttentionEvent.new().init(self,body,0).init_2($LocalZone))
	else:
		print("AI NULL")
	pass # Replace with function body.
