extends Navigation

var tracking_nodes:= []

func add_tracking_node(node:Spatial):
	tracking_nodes.append(node)
	node.connect("nav_point_shift",self,"_on_tracking_nav_shift")
func _on_tracking_nav_shift(node,new_nav_point,new_nav_mesh):
#	print("IT INDEED SHIFTED")
	if node.get("nav_monitor_radius"):
		#deal with things entering and exiting this track because it moved
		#exiting nodes
		for i in range(node.nav_inrange_nodes.size() - 1, -1, -1):
			var tracked_node=node.nav_inrange_nodes[i]
			var dist_tween = _linear_distance(node,tracked_node)
			if dist_tween>node.nav_monitor_radius:
				node.nav_inrange_nodes.remove(i)
				tracked_node.nav_monitored_by_nodes.erase(node)
				node._on_node_exit_monitor_radius(tracked_node)	
		#Entring nodes
		for tracking_node in tracking_nodes:
			if tracking_node == node:
				continue
			var dist_tween = _linear_distance(node,tracking_node)
			if dist_tween<node.nav_monitor_radius:
				if not (tracking_node in node.nav_inrange_nodes):
					node.nav_inrange_nodes.append(tracking_node)
					tracking_node.nav_monitored_by_nodes.append(node)
					node._on_node_enter_monitor_radius(tracking_node)
	#Check if exiting any trackers
	for i in range(node.nav_monitored_by_nodes.size() - 1, -1, -1):
		var monitored_by_node = node.nav_monitored_by_nodes[i]
		var dist_tween = _linear_distance(node,monitored_by_node)
		if dist_tween>monitored_by_node.nav_monitor_radius:
			node.nav_monitored_by_nodes.remove(i)
			monitored_by_node.nav_inrange_nodes.erase(node)
			monitored_by_node._on_node_exit_monitor_radius(node)
	#Check if entering any trackers	
	for tracking_node in tracking_nodes:
		if tracking_node == node:
			continue
		if tracking_node.get("nav_monitor_radius") == null:
			continue
#		print("Wow, thats a monitoring node")
		var dist_tween = _linear_distance(node,tracking_node)
		if dist_tween<tracking_node.nav_monitor_radius:
			if not(node in tracking_node.nav_inrange_nodes):
				tracking_node.nav_inrange_nodes.append(node)
				node.nav_monitored_by_nodes.append(tracking_node)
				tracking_node._on_node_enter_monitor_radius(node)
	pass
func _linear_distance(nodea:Node,nodeb:Node):
	return (nodea.global_transform.origin- nodeb.global_transform.origin).length()

func _ready():
	pass
