extends Node2D
class_name Inventory

const SlotClass = preload("res://Slot_Test_0.gd")
const ItemClass = preload("res://Item.gd")
const InventoryUI= preload("res://InventoryUI.gd")

export(int) var width
export(int) var height
#const Inventory = preload("res://scenes/Inventory.tscn")
func get_inventory():
	return self

var inventory_ui_s =[]

const NUM_INVENTORY_SLOTS= 60

var inventory = {
	0:["Golden Coin",{
		"Statuses":[{"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]
	}], # --> slot_index: [item_name, item_quantity]
	1:["White Onion",{
		"Statuses":[{"Durability":5,"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]
	}],
	2:["Red Drum",{
		"Initial Contents":{
			0:["Lead",{
				"Statuses":[{"Durability":20,"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]
			}],
			1:["Lead",{
				"Statuses":[{"Durability":20,"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]
			}],
			2:["Lead",{
				"Statuses":[{"Durability":20,"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]
			}]
		},
		"Inventory":null
	}],
	3:["Lead",{
		"Statuses":[
			{"Durability":20,"Moist":10,"Oily":0,"Burning":0,"Smelly":0},
			{"Durability":20,"Moist":0,"Oily":10,"Burning":0,"Smelly":0},
			{"Durability":20,"Moist":0,"Oily":0,"Burning":0,"Smelly":10}
		]
	}],
}
func bind_ui(inventory_ui:InventoryUI):
	inventory_ui_s.append(inventory_ui)

func update_all_ui_s():
	for inventory_ui in inventory_ui_s:
		if inventory_ui!=null:
			inventory_ui.init_inventory()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func append_data(index:int,item_data):
	var item_statuses = null
	if item_data is Array:
		item_statuses=item_data
	elif item_data is Dictionary:
		item_statuses= item_data["Statuses"]
	assert(item_statuses!=null)
	if item_statuses.size()>0:
		inventory[index][1]["Statuses"]+=item_statuses
#	inventory[index][1]=inventory[index][2]["Statuses"].size()
	update_all_ui_s()
	
func num_items_at(index:int):
	return inventory[index][1]["Statuses"].size()
	
func cleave_data(index:int,amount:int)-> Dictionary:
#	assert(amount<=inventory[index][1]["Statuses"].size())
	if amount>inventory[index][1]["Statuses"].size():
		amount = inventory[index][1]["Statuses"].size()
	if amount ==0:
		return {"Statuses":[]}
	var cleaved = inventory[index][1]["Statuses"].slice(0,amount-1)
	inventory[index][1]["Statuses"]=inventory[index][1]["Statuses"].slice(amount,inventory[index][1]["Statuses"].size()-1)
	return {"Statuses":cleaved}
	
func add_item(item_name,item_data):
	var stack_size = JsonData.stack_size(item_name)
#	var remaining_quant=item_quantity
	var statuses= item_data["Statuses"]
	var item_quantity= statuses.size()
	assert(statuses.size()==item_quantity)
	for i in range(NUM_INVENTORY_SLOTS):
#		
		if i in inventory:
			if num_items_at(i)==0: continue
			if inventory[i][0]==item_name:
				var able_to_add= stack_size-num_items_at(i);
				if statuses.size()<=able_to_add:
					append_data(i,statuses)
					update_all_ui_s()
					return
				if able_to_add>0:
					append_data(i,statuses.slice(0,able_to_add-1))
					statuses=statuses.slice(able_to_add,statuses.size())
		else:
			if !inventory.has(i)||num_items_at(i)==0:
				if statuses.size()<=stack_size:
					inventory[i]= [item_name,{"Statuses":statuses}]
					update_all_ui_s()
					return
				inventory[i]= [item_name,{"Statuses":statuses.slice(0,stack_size-1)}]
				statuses= statuses.slice(stack_size,statuses.size())
#				assert(statuses.size()==remaining_quant)
			
			
	
func add_item_to_empty(item: ItemClass, slot:SlotClass):
	inventory[slot.slot_index]= [item.item_name,item.item_data]
	update_all_ui_s()
func add_item_to_empty_amt(item: ItemClass, slot:SlotClass,amt:int):
	inventory[slot.slot_index]= [item.item_name,item.cleave_data(amt)]
	update_all_ui_s()
func add_item_to_empty_index(item: ItemClass, slot_index:int):
	inventory[slot_index]= [item.item_name,item.item_data]
	update_all_ui_s()

func shift_items_between_indexes(index_a:int,index_b:int):
	if index_a in inventory:
		if !(index_b in inventory):
			inventory[index_b]= inventory[index_a]
			inventory.erase(index_a)
		else:
			if inventory[index_a][0]==inventory[index_b][0]:
				var stack_size= JsonData.stack_size(inventory[index_a][0])		
				var able_to_add= stack_size-num_items_at(index_b)
				if able_to_add<=num_items_at(index_a):
					append_data(index_b,cleave_data(index_a,able_to_add))
#					inventory[index_b][1]=inventory[index_b][1]+able_to_add
#					inventory[index_a][1]=inventory[index_a][1]-able_to_add
				else:
					append_data(index_b,cleave_data(index_a,num_items_at(index_a)))
#					inventory[index_b][1]=inventory[index_b][1]+inventory[index_a][1]
					inventory.erase(index_a)

func shift_amt_items_between_indexes(index_a:int,index_b:int,amt:int):
	if index_a in inventory:
		if !(index_b in inventory):
			inventory[index_b]= [inventory[index_a][0],cleave_data(index_a,amt)]
			assert(num_items_at(index_b)<=JsonData.stack_size(inventory[index_b][0]))
		else:
			if inventory[index_a][0]==inventory[index_b][0]:
				var stack_size= JsonData.stack_size(inventory[index_b][0])		
				var able_to_add= stack_size-num_items_at(index_b)
				if able_to_add>0:
					if able_to_add<= amt:
						append_data(index_b,cleave_data(index_a,able_to_add))
					else:
						append_data(index_b,cleave_data(index_a,amt))
		if num_items_at(index_a)==0:
			inventory.erase(index_a)
		
	
func update_slot_item(slot:SlotClass):
	if slot.item!=null:
		inventory[slot.slot_index]= [slot.item.item_name,slot.item.item_data]
	else:
		inventory.erase(slot.slot_index)
	update_all_ui_s() 		
	
func set_slot_data(slot,slot_data):
	inventory[slot.slot_index]= slot_data
	update_all_ui_s()

func remove_item(slot:SlotClass):
	inventory.erase(slot.slot_index)
	
func slot_full(index:int):
	if ! (index in inventory):
		return false
	return JsonData.stack_size(inventory[index][0])>=num_items_at(index)
func can_add_to(item_name,index:int):
	if ! (index in inventory):
		return true
	if item_name != inventory[index][0]:
		return false
	return !slot_full(index)
func do_physics():
	for row in range(10-1,-1,-1):
		for col in range(6):
			var ind= row*6+col
			if ind in inventory:
				var around=[]
				if col>0:
					around.append((row)*6+col-1)
					if row<9:
						around.append((row+1)*6+col-1)
				if col<5:
					around.append((row)*6+col+1)
					if row<9:
						around.append((row+1)*6+col+1)

				var good_around=[]
				for index_arr in around:
					good_around.append(index_arr)
				if num_items_at(ind)> good_around.size()+JsonData.spew_amt(inventory[ind][0]):
					for index_arr in good_around:
						shift_amt_items_between_indexes(ind,index_arr,1)
#
#	for row in range(10-1,-1,-1):
##		print(row)
#		for col in range(6):
#			var ind= row*6+col
#			if ind in inventory:
#				var ind_below= (row+1)*6+col
#				if JsonData.gravity(inventory[ind][0]):
#					if row<9:
#						shift_items_between_indexes(ind,ind_below)
#

	update_all_ui_s()
	pass
				
				
				
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
