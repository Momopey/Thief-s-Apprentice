extends Node2D
var ItemDropScene = preload("res://scenes/ItemDrop.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _timer = null
export(bool) var active
# Called when the node enters the scene tree for the first time.
func _ready():
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.set_wait_time(1)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	pass # Replace with function body.
func _on_timer_timeout():
	if active:
		var item_drop = ItemDropScene.instance()
		get_parent().add_child(item_drop)
		item_drop.global_position=global_position
#	print("Instancing"+item_drop.name)
#	itemdrop.global_position=global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
