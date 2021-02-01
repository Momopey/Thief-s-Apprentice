extends Node2D

onready var text_label = $RichTextLabel
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.connect("mouse_entered",self,"_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")
	$RichTextLabel.get_v_scroll().connect("mouse_entered",self,"_on_mouse_entered")
	$RichTextLabel.get_v_scroll().connect("mouse_exited",self,"_on_mouse_exited")
	close_timer= Timer.new()
	add_child(close_timer)
	close_timer.set_wait_time(1.4)
	close_timer.set_one_shot(true)
	close_timer.connect("timeout",self,"close")
	close_timer.start()

var user_interface
var close_timer;
func _on_mouse_entered():
	print("Mouse entered")
	close_timer.stop()

func _on_mouse_exited():
	print("Mouse exited")
	close_timer.set_wait_time(1.2)
	close_timer.start()
																								
	
func set_text(text):
	text_label.text=text
	
func close():
	visible=false
	if user_interface:
		user_interface.close_hover()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
