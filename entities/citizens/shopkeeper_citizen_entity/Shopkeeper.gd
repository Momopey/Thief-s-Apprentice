extends Spatial

export (Array,NodePath) var chest_paths
var chests := []
export (NodePath) var nav_path
var nav
export (NodePath) var shopkeeper_entity_path
var shopkeeper_entity 
func get_nav():
	return get_node(nav_path)
func _ready():
	shopkeeper_entity= get_node(shopkeeper_entity_path)
	nav = get_nav()
	for chest_path in chest_paths:
		chests.append(get_node(chest_path))	
	shopkeeper_entity.chests = chests
	shopkeeper_entity.prep_chests()
	pass
