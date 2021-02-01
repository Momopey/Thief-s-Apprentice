extends Node

var item_data: Dictionary


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	item_data= LoadData("res://datas/ItemData.json")
	pass # Replace with function body.
	
func LoadData(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path,File.READ)
	json_data= JSON.parse(file_data.get_as_text());
	file_data.close()
	return json_data.result;
func stack_size(item_name):
	return item_data[item_name]["StackSize"]
func item_category(item_name):
	return item_data[item_name]["ItemCategory"]
func spew_amt(item_name):
	return item_data[item_name]["SpewAmt"]
func gravity(item_name):
	return item_data[item_name]["Gravity"]
func properties(item_name):
	return item_data[item_name]["Properties"]
func description(item_name):
	return item_data[item_name]["Description"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
