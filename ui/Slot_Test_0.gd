extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ItemClass= preload("res://ui/item/Item.tscn")
var InventoryUI = load("res://ui/inventories/InventoryUI.gd")

export(NodePath) var inventory_node_path
onready var inventory_node= get_node(inventory_node_path)


var item = null
var slot_index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered",self,"_on_mouse_entered")
	connect("mouse_exited",self,"_on_mouse_exited")
	
	assert(inventory_node is InventoryUI)
#	if randi()%2==0:
#		item= ItemClass.instance()
#		add_child(item);
#	init_item()
	pass # Replace with function body.
	
func init_item(item_data):
	if item == null:
		item= ItemClass.instance()
		add_child(item);
	item.set_item(item_data)
func remove_item():
	if item !=null:
		item.queue_free()
	item=null;
func load_item():
	init_item(inventory_node.inventory.inventory[slot_index])
	
		
func pickFromSlot():
	remove_child(item)
#	var inventoryNode = find_parent("InventoryUI")
#	var parent = get_parent()
#	for i in range(3):
#		print(parent.name)
#		parent = parent.get_parent()
#	if inventoryNode==null:
#		print("why?")
#	else:
	inventory_node.add_child(item)
	item=null
	
func putIntoSlot(new_item):
	item= new_item
	item.position = Vector2(0,0)
#	var inventoryNode = find_parent("InventoryUI")
	inventory_node.remove_child(item)
	add_child(item)
	
func show_hover_text():
	if item!=null:
		GameManager.user_interface.show_basic_hover_text(get_global_mouse_position(),JsonData.description(item.item_name)+
				"\n \n "+String(inventory_node.inventory.inventory[slot_index]["Item Name"])+":"+String(inventory_node.inventory.num_items_at(slot_index))+
				"\n Data:"+JSON.print(inventory_node.inventory.inventory[slot_index]["Statuses"],"  "))

func _on_mouse_entered():
#	show_hover_text()
	pass
#	
	
func _on_mouse_exited():
	pass
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
