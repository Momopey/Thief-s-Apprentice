extends Node2D


export(NodePath) var moist_icon_path
export(NodePath) var burning_icon_path
export(NodePath) var oily_icon_path
export(NodePath) var smelly_icon_path
var moist_icon
var burning_icon
var oily_icon
var smelly_icon
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var item_name
var item_data=null

# Called when the node enters the scene tree for the first time.
func _ready():
	moist_icon= get_node(moist_icon_path)
	burning_icon= get_node(burning_icon_path)
	oily_icon= get_node(oily_icon_path)
	smelly_icon = get_node(smelly_icon_path)
	
	var randval =randi()%3;
	if randval==0:
		item_name="Golden Coin"
#		/$TextureRect.texture= load("res://item_icons/coin_crap.png")
	elif randval==1:
		item_name="Golden Coin"
#		$TextureRect.texture= load("res://item_icons/coinStack_crap.png")
	else: 
		item_name= "Ruby Shard"
#	
#	$TextureRect.texture= load("res://item_icons/"+item_name+".png")
	var stack_size= int(JsonData.item_data[item_name]["StackSize"])
#	item_quantity= stack_size
#	item_quantity=1;
#	item_quantity= randi()%stack_size+1
	update_item()
#	
func set_item(i_data):
	item_name= i_data["Item Name"]
#	item_quantity = i_quantity
	item_data=i_data
	update_item();		
	pass # Replace with function body.
	
func cleave_data(amount:int)-> Dictionary:
	assert(amount<=item_data["Statuses"].size())
	if amount ==0:
		return {"Statuses":[]}
	var cleaved = item_data["Statuses"].slice(0,amount-1)
	item_data["Statuses"]=item_data["Statuses"].slice(amount,item_data["Statuses"].size()-1)
#	item_quantity=item_data["Statuses"].size()
	update_item()
	return {"Statuses":cleaved}
	
func item_quantity():
	return item_data["Statuses"].size()
func update_item():
	if item_data==null:
		item_data = {"Statuses":
			[{"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]
		}
	if not "Statuses" in item_data:
		item_data["Statuses"]=[{"Moist":0,"Oily":0,"Burning":0,"Smelly":0}]
	assert(item_data!=null)
	var show_stack_amt= int(JsonData.item_data[item_name]["ShowStackedTexAmt"])
#	
#	var stack_size= int(JsonData.item_data[item_name]["StackSize"])
#	if "Statuses" in item_data:
	if item_quantity()<=0:
		visible = false
	else:
		visible = true
		
	if(show_stack_amt>=0):
		if(item_quantity()<show_stack_amt):
			$TextureRect.texture= load("res://item_icons/"+item_name+".png")
		else:
			$TextureRect.texture= load("res://item_icons/"+item_name+"_Stacked.png")
	else:
		$TextureRect.texture= load("res://item_icons/"+item_name+".png")
	
	if(item_quantity()<=1):
		$Label.visible=false;
	else:
		$Label.visible=true;
		$Label.text= String(item_quantity())
		
	var any_moist:= false
	var any_burning:=false
	var any_oily:=false
	var any_smelly:=false
	if item_data!=null:
#		print(JSON.print(item_data))
		if "Statuses" in item_data:
			if item_data["Statuses"]!=null:
				for data in item_data["Statuses"]:
					if data["Moist"]>0:
						any_moist=true
					if data["Burning"]>0:
						any_burning=true
					if data["Oily"]>0:
						any_oily=true
					if data["Smelly"]>0:
						any_smelly=true

				moist_icon.visible=any_moist
				burning_icon.visible= any_burning
				oily_icon.visible= any_oily
				smelly_icon.visible=  any_smelly
	
		
func get_data():
	return [item_name,item_data]

#func add_item_quantity(amount_to_add):
#	item_quantity+=amount_to_add
#	update_item()
	
#func remove_item_quantity(amount_to_remove):
#	item_quantity-=amount_to_remove
#	update_item()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
