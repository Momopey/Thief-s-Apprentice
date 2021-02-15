extends Node

onready var _Body_AnimationPlayer = self.find_node("Body_AnimationPlayer")
onready var _Body_LBL = self.find_node("Body_Label")
onready var _Dialog_Box = self.find_node("Dialog_Box")
onready var _Speaker_LBL = self.find_node("Speaker_Label")
onready var _SpaceBar_Icon = self.find_node("GridContainer")

export(Array,NodePath) var prompt_box_paths
var prompt_boxes := []

var _did = 0
var _nid = 0
var _final_nid = 0
var _Story_Reader
export(Resource) var story_resource
export(String) var story_title

var player 
var speaker
# Virtual Methods

func _ready():
	for prompt_box_path in prompt_box_paths:
		prompt_boxes.append(get_node(prompt_box_path))
	
	var Story_Reader_Class = load("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
	_Story_Reader = Story_Reader_Class.new()
	var story = story_resource
	print(story.TYPE)
	_Story_Reader.read(story)
	
	_Dialog_Box.visible = false
	_SpaceBar_Icon.visible = false
	
	play_dialog(story_title)


func _input(event):
	if event is InputEventKey:
		if event.pressed :
			if event.scancode == KEY_SPACE:
#				_on_Dialog_Player_pressed_spacebar()	
				pass
			if event.scancode == KEY_1:
				_on_press_number(1)
			if event.scancode == KEY_2:
				_on_press_number(2)
			if event.scancode == KEY_3:
				_on_press_number(3)
			if event.scancode == KEY_4:
				_on_press_number(4)
# Callback Methods
var timer;
func _on_Body_AnimationPlayer_animation_finished(anim_name):
	_SpaceBar_Icon.visible = true
	if "Auto" in data:
		if timer:
			clear_timer()
		timer = Timer.new()
		add_child(timer)
		print("Making timer")
		timer.autostart=true
		timer.one_shot= true
		timer.wait_time = data["Auto"]
		timer.start()
		timer.connect("timeout",self,"_on_timer_end")
		

func _on_timer_end():
	if "Continue" in data:
		_SpaceBar_Icon.visible = false
		if _Story_Reader.get_slot_count(_did, _nid)>data["Continue"]:
			_get_next_node(data["Continue"])
			if _is_playing():
				_play_node()
		else:
			printerr("Auto continue giving index out of range")
func clear_timer():
	if timer:
		timer.queue_free();
		timer= null;

#func _on_Dialog_Player_pressed_spacebar():
#	if _is_waiting():
#		_SpaceBar_Icon.visible = false
#		_get_next_node()
#		if _is_playing():
#			_play_node()
func _on_press_number(num:int):
	if _is_waiting():
		if data["Outs"].size()>num-1:
			_SpaceBar_Icon.visible = false
			var out =data["Outs"][num-1]["Out"];
			if _Story_Reader.get_slot_count(_did, _nid)>out:
				if "Dialog End Call" in data:
					for proc in data["Dialog End Call"]:
						if "Func" in proc:
							get(proc["On"]).call(proc["Func"])
				_get_next_node(out)
				if _is_playing():
					_play_node()
	pass
	
# Public Methods

func play_dialog(record_name : String):
	_did = _Story_Reader.get_did_via_record_name(record_name)
	_nid = self._Story_Reader.get_nid_via_exact_text(_did, "<start>")
	_final_nid = _Story_Reader.get_nid_via_exact_text(_did, "<end>")
	_get_next_node()
	_play_node()
	clear_timer()
	_Dialog_Box.visible = true

# Private Methods

func _is_playing():
	return _Dialog_Box.visible


func _is_waiting():
	return _SpaceBar_Icon.visible


func _get_next_node(ind:int = 0):
	_nid = _Story_Reader.get_nid_from_slot(_did, _nid, ind)
	if _nid == _final_nid:
		_Dialog_Box.visible = false
		player.user_interface.hide_dialog(self,speaker)

var data : Dictionary
func _play_node():
	var text = _Story_Reader.get_text(_did, _nid)
	var result :JSONParseResult= JSON.parse(text)
	if result.error==OK:
		data = result.result
		var speaker_text = data["Speaker"]
		_Speaker_LBL.text = speaker_text
		if "Dialog BBCode" in data:
			_Body_LBL.bbcode_enabled = true
			_Body_LBL.bbcode_text = data["Dialog BBCode"]
		else:
			_Body_LBL.bbcode_enabled = false
			_Body_LBL.text =  data["Dialog"]
		
		
		if "Dialog Start Call" in data:
			for proc in data["Dialog Start Call"]:
				if "Func" in proc:
					get(proc["On"]).call(proc["Func"])
#					if self.has_
#					match proc["On"]:
#						"player":
#							player.call(proc["Func"])s
		
		
		if speaker.get("dialog_name") == speaker_text:
			print("IT IS THE SPEAKER TALKING")
			$Dialog_Box/Body_NinePatchRect/Speaker_NinePatchRect/TextureRect.texture = speaker.dialog_speaker_texture
		print("Player name:"+player.get("dialog_name")+" comp "+speaker_text)
		if player.get("dialog_name") == speaker_text:
			print("Setting as player speaker texture")
			$Dialog_Box/Body_NinePatchRect/Speaker_NinePatchRect/TextureRect.texture = player.dialog_speaker_texture
		
#		_Body_LBL.text = dialog_text
		for prompt_box in prompt_boxes:
			prompt_box.visible = false
		for i in range(data["Outs"].size()):
			var prompt_box = prompt_boxes[i]
			prompt_box.visible = true
			prompt_box.label.text= str(i+1)+": "+ data["Outs"][i]["Prompt"]
	else:
		print("ERROR:")
		print(text)
	_Body_AnimationPlayer.play("TextDisplay")
