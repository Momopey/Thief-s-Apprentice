extends Spatial


var ItemDrop3DScene = preload("res://scenes/ItemDrop3D.tscn")

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
		var item_drop = ItemDrop3DScene.instance()
		get_parent().add_child(item_drop)
		item_drop.global_transform.origin=global_transform.origin
