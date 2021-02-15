extends Spatial
#export(NodePath) var nav_path
var nav




var near_nav_point:Vector3
var near_nav_mesh:Object # NavMeshInstance
export(float) var nav_shift_radius:float = 1
export(bool) var nav_monitoring = false 
export(float) var nav_monitor_radius:float = 14
var nav_inrange_nodes := []
var nav_monitored_by_nodes := []
signal nav_point_shift(_self,nav_point_vec3,nav_mesh)

#Path to the actuall enitity regarding 
export(NodePath) var entity_path
var entity
func _ready():
#	nav = get_node(nav_path)
	entity= get_node(entity_path)
	if not nav_monitoring:
		nav_monitor_radius= -1
#	nav.add_
func connect_to_nav(_nav):
	nav = _nav
	if nav:
		nav.add_tracking_node(self)

signal _on_node_enter_monitor_radius(node)
signal _on_node_exit_monitor_radius(node)

func _on_node_enter_monitor_radius(node:Node):
	if node.get("entity"):
		emit_signal("_on_node_enter_monitor_radius",node.get("entity"))
	else:
		emit_signal("_on_node_enter_monitor_radius",node)
	pass
func _on_node_exit_monitor_radius(node:Node):
	if node.get("entity"):
		emit_signal("_on_node_exit_monitor_radius",node.get("entity"))
	else:
		emit_signal("_on_node_exit_monitor_radius",node)
	pass

func _physics_process(delta):
	if near_nav_point == global_transform.origin:
		return
	if nav:
		if (near_nav_point-global_transform.origin).length()>nav_shift_radius:
			var new_near_nav_point =  nav.get_closest_point(global_transform.origin)
			var new_near_nav_mesh = nav.get_closest_point_owner(global_transform.origin)
			if (new_near_nav_mesh != near_nav_mesh) or (new_near_nav_point != near_nav_point):
				near_nav_point = new_near_nav_point
				near_nav_mesh  = new_near_nav_mesh
				emit_signal("nav_point_shift",self,near_nav_point,near_nav_mesh) 
