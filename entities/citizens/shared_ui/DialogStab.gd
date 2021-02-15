extends Spatial


func _ready():
	$Viewport/Textbox/AnimationPlayer.connect("animation_finished",self,"_on_Fade_Out_finished")
	pass

var text_stabbing := false
var text :String
var text_scale := 1.0
var appear_length :float = 5	

func start_text_stab(_text:String,_text_scale:float,_appear_length:float,override:= false):
	if (not text_stabbing) or override:
		text_stabbing = true
		text = _text
		text_scale = _text_scale
		appear_length = _appear_length
		$Quad.visible = true
		$Viewport/Textbox/AnimationPlayer.play("Fade in")
		$Viewport/Textbox/Panel/RichTextLabel.bbcode_text = _text
		$Viewport/Textbox/Panel/RichTextLabel.rect_size = Vector2(500.0/text_scale,100.0/text_scale)
		$Viewport/Textbox/Panel/RichTextLabel.rect_scale = Vector2(text_scale,text_scale)
		$DialogStabTimer.wait_time = _appear_length
		$DialogStabTimer.one_shot= true
		$DialogStabTimer.start()


func _on_DialogStabTimer_timeout():
#	print("ON DIALOGSTABTIMER TIMEzoUT")
	
	$Viewport/Textbox/AnimationPlayer.play("Fade out")
	
	
	pass # Replace with function body.
func _on_Fade_Out_finished(animation_name):
	if animation_name == "Fade out":
#		print("ON DIALOGSTABTIMER TIMEzoUT- FADE OUT FINISHED")
		text_stabbing = false;
		text = ""
		appear_length = -1;
		$Quad.visible = false
	
func _process(delta):
	var camera_pos = get_viewport().get_camera().global_transform.origin
#	camera_pos.y = 0

	look_at(camera_pos, Vector3(0, 1, 0))


