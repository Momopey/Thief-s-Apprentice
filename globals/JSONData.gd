extends Node

var item_data: Dictionary


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var path := "user://datas/ItemData.json"

var default_data ={
	"Golden Coin":{
		"ItemCategory":"Resource",
		"ShowStackedTexAmt":3,
		"StackSize": 9,
		"Gravity":true,
		"SpewAmt":3,
		"Description": "Valuable mint gold coins",
		"Properties":{},
		"Value": 9
	},
	"Ruby Shard":{
		"ItemCategory":"Resource",
		"ShowStackedTexAmt":-1,
		"StackSize":9,
		"Gravity":true,
		"SpewAmt":1,
		"Description": "Rough cut ruby shard",
		"Value": 3
	},
	"White Onion":{
		"ItemCategory":"Resource",
		"ShowStackedTexAmt": -1,
		"StackSize": 1,
		"Gravity":true,
		"SpewAmt":0,
		"Description": "Astonishingly large white onion",
		"Properties":{},
		"Value": 1
	},
	"Lead":{
		"ItemCategory":"Resource",
		"ShowStackedTexAmt":-1,
		"StackSize":3,
		"Gravity":false,
		"SpewAmt":100000,
		"Description":"Large piece of black lead",
		"Properties":{},
		"Value": 6
	},
	"Red Drum":{
		"ItemCategory":"Container",
		"ShowStackedTexAmt":-1,
		"StackSize": 1,
		"Gravity":false,
		"SpewAmt":100,
		"Description": "Small red oil drum",
		"Properties":{
			"Width":3,
			"Height":3,
			"InventoryUISceneName":"InventorySubcontainer"
		},
		"Value": 12
	}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	item_data = default_data
#	item_data= LoadData(path)
#	SaveData()
	pass # Replace with function body.
	
#func LoadData(file_path):
#	var json_data
#	var file_data = File.new()
#	if not file_data.file_exists(path):
#		return default_data
#	file_data.open(file_path,File.READ)
#	json_data= JSON.parse(file_data.get_as_text());
#	file_data.close()
#	return json_data.result;
#func SaveData():
#	var file_data = File.new()
#	file_data.open(path,File.WRITE)
#	file_data.store_line(to_json(item_data))
#	file_data.close()
	
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
func value(item_name):
	return item_data[item_name]["Value"]
func description(item_name):
	return item_data[item_name]["Description"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
