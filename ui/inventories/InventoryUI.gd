extends Node2D

const SlotClass = preload("res://ui/Slot_Test_0.gd")
var InventoryClass = load("res://entities/Inventory.gd")
var inventory_slots

export(NodePath) var ui_path
var ui
var client

export(NodePath) var inventory_source
export(NodePath) var grid_container_path
var inventory # :Inventory

#export(NodePath) var user_interface_path
#var user_interface


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if !ui:
		ui = get_node(ui_path)
	client = ui.get_client()
#	print(get_node(ui_path).get_client())
	assert(client)
	if inventory==null:
		assert(get_node(inventory_source).has_method("get_inventory"))
		inventory= get_node(inventory_source).get_inventory()
	print("InventoryUI using inventory:"+String(inventory.name))
	inventory_slots=get_node(grid_container_path)
	inventory_slots.columns=inventory.width
#	for inv_slot in inventory_slots.get_children():
	assert(inventory is InventoryClass)
	inventory.bind_ui(self)
	for ind in range(inventory_slots.get_children().size()):
		var inv_slot= inventory_slots.get_children()[ind]
		inv_slot.slot_index= ind
		inv_slot.connect("gui_input",self,"slot_gui_input",[inv_slot])
#		print("bound:"+String(name)+"  "+String(inv_slot.name))
	init_inventory()
	pass # Replace with function body.
	
func init_inventory():
	var slots=inventory_slots.get_children()
	for i in range(slots.size()):
		if inventory.inventory.has(i):
#			if inventory.inventory[i].size()>2:
			slots[i].init_item(inventory.inventory[i])
#			else:
#				slots[i].init_item(inventory.inventory[i][0],inventory.inventory[i][1]})
		else: 
			slots[i].remove_item();
	
func swap_with_slot(slot:SlotClass):
	var temp_item= slot.item
	slot.pickFromSlot()
	inventory.remove_item(slot)
	inventory.add_item_to_empty(client.holding_item,slot)
	inventory.update_slot_item(slot)
	client.remove_holding_item()
	client.holding_item=temp_item
var num_times=0



func slot_gui_input(event: InputEvent,slot: SlotClass):
	
	num_times+=1
	if event is InputEventMouseButton:
		#LMB pressed
		if event.pressed:
			if client.open:
				if slot== client.open_container_slot:
					client.close_container()
			if event.button_index== BUTTON_LEFT:
				#Currently Holding Item
				if client.holding_item !=null:
					#Empty Slot
					if !slot.item:
						left_click_empty_slot(slot)
					else:
						#Same type of item
						if client.holding_item.item_name==slot.item.item_name:
							left_click_same_item(event,slot)
						#Sqap Items
						else:
							left_click_different_item(event,slot)
					ui.play_click();
				#Pickup item
				elif slot.item:
					left_click_not_holding(slot)
					ui.play_click();
			if event.button_index== BUTTON_RIGHT:
				#Empty Slot
				var inv_mod= false
				if slot.item:
					var item = slot.item
					if JsonData.item_category(item.item_name) == "Container":
						if client.open:
							client.close_container()
							
						inv_mod=true
						client.open_container(slot,inventory)
				if not inv_mod:
					if client.holding_item ==null||client.holding_item.item_quantity()==0:
						slot.show_hover_text()
					else:
						if !slot.item:
							right_click_empty_slot(slot)
						else:
							if(slot.item.item_name==client.holding_item.item_name):\
								if(slot.item.item_quantity()<JsonData.stack_size(slot.item.item_name)):
									inventory.append_data(slot.slot_index,client.holding_item.cleave_data(1))
									if client.holding_item.item_quantity()==0:
										client.remove_holding_item()
					
									
			
#						chest_inventory_ui.inventory=interactive.inventory_source()
#						user_interface.show_inventory_ui(chest_inventory_ui,interactive)


func left_click_not_holding(slot)	:
	inventory.remove_item(slot)
	client.holding_item=slot.item
	slot.pickFromSlot()
	inventory.update_slot_item(slot)
	client.holding_item.global_position= get_global_mouse_position();

func left_click_empty_slot(slot:SlotClass):
	print("Slot interacted:"+String(num_times)+" Left clicked empty slot") 
	inventory.add_item_to_empty(client.holding_item,slot)
#	slot.putIntoSlot(client.holding_item)
#	client.holding_item=null;
	client.remove_holding_item()
	
func right_click_empty_slot(slot:SlotClass):
	inventory.add_item_to_empty_amt(client.holding_item,slot,1)
	if client.holding_item.item_quantity()==0:
		client.remove_holding_item()

func left_click_different_item(event,slot):
#	inventory.remove_item(slot)
#	inventory.add_item_to_empty(client.holding_item,slot)
	swap_with_slot(slot)
	client.holding_item.global_position= event.global_position;

func left_click_same_item(event,slot):
	var item_name= client.holding_item.item_name
	var stack_size = JsonData.item_data[item_name]["StackSize"]
	var able_to_add= stack_size-slot.item.item_quantity();

	#Add all of the held item to the slot item
	if able_to_add>=client.holding_item.item_quantity():
		inventory.append_data(slot.slot_index,client.holding_item.item_data)
#		inventory.add_quantity_to(client.holding_item.item_quantity,slot)
#		slot.item.add_item_quantity(client.holding_item.item_quantity);
		inventory.update_slot_item(slot)
		client.remove_holding_item()
	elif able_to_add==0:
		swap_with_slot(slot)
		client.holding_item.global_position= event.global_position;
	#Remove amount from held item and give to slot item
	else:
#		slot.item.add_item_quantity(able_to_add)
		inventory.append_data(slot.slot_index,client.holding_item.cleave_data(able_to_add));
		inventory.update_slot_item(slot)
func _input(event):
	if client.holding_item:
		client.holding_item.global_position= get_global_mouse_position();

#func gui_input():

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
