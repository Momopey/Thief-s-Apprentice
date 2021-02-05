extends RichTextLabel

export(NodePath) var player_path
var player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "OBJECTIVE: LOOT TO INCREASE UR VALUE \n"
	text+="Value:"+String(PlayerInventory.get_value())+"\n"
	pass
