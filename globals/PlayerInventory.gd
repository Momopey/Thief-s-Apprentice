extends Inventory

var holding_item = null

var player = null
var open = false
var open_container_slot=null
var open_container_ui=null
var InventoryClass = load("res://entities/Inventory.gd")


func remove_holding_item():
	if holding_item!=null:
		holding_item.queue_free()
		holding_item=null
		
func _ready():
	width = 6
	height = 10
	
var housing_inventory
func open_container(slot,inventory_of):
	var item=slot.item
	var props = JsonData.properties(item.item_name)
	var inventory_ui_path = "res://ui/inventories/"+props["InventoryUISceneName"]+".tscn" 
	var container_inventory_ui = load(inventory_ui_path).instance()
#	var container_inventory = inventory_of.inventory[slot.slot_index]["Inventory"]
#	if container_inventory ==null:
	var container_inventory = InventoryClass.new()
	if not "Type" in inventory_of.inventory[slot.slot_index]:
		return
	if inventory_of.inventory[slot.slot_index]["Type"] != "Container":
		return
	container_inventory.inventory= inventory_of.inventory[slot.slot_index]["Initial Contents"]
	container_inventory.width= JsonData.properties(item.item_name)["Width"]
	container_inventory.height= JsonData.properties(item.item_name)["Height"]
#	inventory_of.inventory[slot.slot_index]["Inventory"]=container_inventory
	container_inventory_ui.inventory=container_inventory
	open_container_ui=container_inventory_ui
	open_container_slot=slot
	housing_inventory= inventory_of
	GameManager.user_interface.show_inventory_ui(container_inventory_ui,self)


func close_container():
	if housing_inventory:
		commit_open_container_ui_data()
		GameManager.user_interface.hide_inventory_ui(open_container_ui,self)
		open_container_ui=null
		open_container_slot=null
		open=false
func commit_open_container_ui_data():
	if housing_inventory and open_container_slot:
		housing_inventory.inventory[open_container_slot.slot_index]["Initial Contents"]= open_container_ui.inventory.inventory
	
func prep_value_get():
	commit_open_container_ui_data()
