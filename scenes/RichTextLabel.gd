extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var ui_path
var client

# Called when the node enters the scene tree for the first time.
func _ready():
	client = get_node(ui_path).client
	pass # Replace with function body.
var time := 0 
func _process(delta):
	time+=1
#	text="Value:"+String(client.get_value())+"\n"
#	text+=JSON.print(client.inventory," ")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
