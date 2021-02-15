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

var nav:Navigation


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

export (NodePath) var shopkeeper_path
var shopkeeper :Node	
var chests := []
export(NodePath) var nav_target_path
var nav_target
var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	ai = CitizenAI.new()
	ai.init(self,[PreventTheftShopkeeperCitizenGoal.new()])
	shopkeeper = get_node(shopkeeper_path)
	nav = shopkeeper.get_nav()
	nav_target = get_node(nav_target_path)
	nav_target.connect_to_nav(nav)
	chests = shopkeeper.chests
	if is_server():
		assert(nav is Navigation)
		timer = get_node(timer_path)
	#	player_client = GameManager.clients[0]
		assert(timer is Timer)
#		nav.add_tracking_node(self)
		
#	for chest_path in chest_paths:
#		chests.append(get_node(chest_path))	
	
#		get_node(chest_path).connect("attention_event",self,"_bruh")
	
	pass # Replace with function body.
#func _bruh(data):
#	print("BRUH YEP")
func prep_chests():
	for chest in chests:
		print("Chest:",chest)
		ai.on_object_attend(chest,AreaEnterAttentionEvent.new().init(self,chest,0).init_2(nav_target))

class PreventTheftShopkeeperCitizenGoal extends CitizenGoal:
	func node_to_focus(object:Node,attention_event):
		if attention_event is AreaEnterAttentionEvent:
			if attention_event.area == ai.citizen.nav_target:
#				print("LOCALZONE ENTERED:"+ str(attention_event.object))
				if attention_event.subject in ai.citizen.chests:
					return ChestInspectShopkeeperCitizenFocus.new().init(ai,self,object)
		if attention_event is InteractChestAttentionEvent:
			return SuspiciousSubjectShopkeeperCitizenFocus.new().init(ai,self,attention_event.actor)
		
		return null
	func focused_event_to_target(focus,attention_event): # -> CitizenTarget
		if focus is SuspiciousSubjectShopkeeperCitizenFocus:
			if focus.salience>3:
				print("bruh")
				print_stack()
				return SuspiciousSubjectShopkeeperCitizenTarget.new().init(ai,self,focus)
#		if focus is ChestInspectShopkeeperCitizenFocus:
#			return ChestInspectShopkeeperCitizenTarget.new().init(ai,self,focus.object)
		return null
	func goal_process(delta):
		var best_found := false
		for focus in ai.focuses:
			if focus is ChestInspectShopkeeperCitizenFocus:
				if not best_found:
					focus.salience -= 3
					ai.add_target(ChestInspectShopkeeperCitizenTarget.new().init(ai,self,focus))
					best_found = true
				else: 
					focus.salience += ai.citizen.rng.randi_range(1,2)
					if focus.salience>4:
						focus.salience = 4
						
				continue
		
class ChestInspectShopkeeperCitizenFocus extends CitizenFocus:
	func on_attention_event(attention_event):
		salience+=1
		pass
class ChestInspectShopkeeperCitizenTarget extends CitizenTarget:
	func on_activate():
		ai.citizen.get_node("DialogStab").start_text_stab("\n[center][wave amp=50 freq=20] Checking up on chest numero "+ str(ai.citizen.chests.find(object)) +"[/wave][/center]",1,2,true)
		prominence = 5;
#		print("now going to chest")		
		pass
		
	func on_process(delta):
		if (object.global_transform.origin- ai.citizen.global_transform.origin).length()<3:
			kill()
		pass
		
	func on_physics_process(delta):
		ai.citizen.targeting= true
		ai.citizen.target_loc = object.global_transform.origin
		if not object in ai.citizen.chests:
			print("IT IS PLAYER?");
		
	func on_kill():
		ai.citizen.targeting= false
		
#		print("Killing chest inspect") G
		
		
class SuspiciousSubjectShopkeeperCitizenFocus extends CitizenFocus:
	func on_add():
		salience = 5
	func on_attention_event(attention_event):
		salience+=1
		pass
		
class SuspiciousSubjectShopkeeperCitizenTarget extends CitizenTarget:
	func on_activate():
		prominence = 3
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
#		ai.citizen.target_loc = null
		prominence -= 100
		focus.salience -= 10;
		ai.citizen.targeting= false
		print("Killed SuspiciousSubject Targeting ")


var ai:CitizenAI
var targeting := false
var target_loc : Vector3
var vel = Vector3()
var MAX_MOVE_ACCEL:float = 30

#var near_nav_point:Vector3
#var near_nav_mesh:Object # NavMeshInstance
#var nav_shift_radius:float = 1
#var nav_monitor_radius:float = 14
#var nav_inrange_nodes := []
#var nav_monitored_by_nodes := []
#signal nav_point_shift(_self,nav_point_vec3,nav_mesh)
#
#func _on_node_enter_monitor_radius(node:Node):
#	print("WOW, A NODE ENTERED MY MONITOR RADIUS WOW WOWOWOWOWOWO :",node)
#	pass
#func _on_node_exit_monitor_radius(node:Node):
#	pass
#	print("WOW, A NODE EXITED MY MONITOR RADIUS WOW WOWOWOWOWOWO :",node)

var counttt= 0
func _physics_process(delta):
	if is_server():
		player_client = GameManager.clients[0]
		ai.on_physics_process(delta)
		if targeting and target_loc:
			if path_node<path.size():
				var direction = (path[path_node]-global_transform.origin)
				if direction.length()<1:
					path_node+=1
				else:
					vel = vel.move_toward(direction.normalized()*MOVE_SPEED,MAX_MOVE_ACCEL*delta)
					vel = move_and_slide(vel,Vector3(0,1,0))
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
	path = nav.get_simple_path(global_transform.origin,target_pos,true)
#	path = [Vector3(rng.randf_range(-20,20),rng.randf_range(-20,20),0)]
	path_node = 0

func _on_Timer_timeout():
	if targeting:
		if target_loc:
			move_to(target_loc)
			var dist = (global_transform.origin-target_loc).length()
			if dist>10:
				timer.wait_time= 5
			elif dist>5:
				timer.wait_time = 2
			else:
				timer.wait_time = 0.5
			pass # Replace with function body.
	
#var points :=  []
func _process(delta):
	
	
	ai.on_process(delta)
	var ig = $attentions/attention_line
	ig.clear()
	for focus in ai.focuses:
		ig.begin(Mesh.PRIMITIVE_LINE_STRIP)
		var points = [global_transform.origin,focus.object.global_transform.origin]
		for p in points:
			ig.add_vertex(p)
		ig.end()
#	if near_nav_point:
#		ig.begin(Mesh.PRIMITIVE_LINE_STRIP)
#		var points = [global_transform.origin,near_nav_point]
#		for p in points:
#			ig.add_vertex(p)
#		ig.end()


func _on_PeriferalZone_body_entered(body):
	if ai:
		ai.on_object_attend(body,AreaEnterAttentionEvent.new().init(self,body,0).init_2(nav_target))
	else:
		print("AI NULL")
	pass # Replace with function body.
	



func _on_GoalProcessTimer_timeout():
	ai.goal_process($GoalProcessTimer.wait_time)
	pass # Replace with function body.


func _on_LocalZone_body_entered(body):
#	print("object entered fuck you:",local_zone)
	if ai:
#		print("Is this working right:",local_zone is Area)
		ai.on_object_attend(body,AreaEnterAttentionEvent.new().init(self,body,0).init_2(nav_target))
	else:
		print("AI NULL")
	pass # Replace with function body.


func _on_NavTarget__on_node_enter_monitor_radius(node):
	print("object entered fuck you:",node)
#	if ai:
#		ai.on_object_attend(node,AreaEnterAttentionEvent.new().init(self,node,0).init_2(nav_target))
#	else:
#		print("AI NULL")
#	pass # Replace with function body.

