extends KinematicBody

const ACCEL = 460
const MAX_SPEED = 225
var velocity = Vector3.ZERO
const ATTRACT_DIST= 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var dialog_scene
export(Resource) var dialog_story_resource
export(String) var dialog_title = "Plains/Battle/Slime"
var open = false
var inventory
signal attention_event(data) 
#
# data["Form"] : "Interact", "Destroy", "Player" ...
# data["Type"] : "Container" ...
# data[ :Type + " Type" ] = "Chest" ...
# data["Disruption level"] = 0....10

func emit_attention_event(attention_event:InteractChestAttentionEvent):
	attention_event.object = self
	emit_signal("attention_event",attention_event)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _physics_process(delta):
#	velocity = velocity.move_toward(Vector3(0,MAX_SPEED,0),ACCEL*delta)
#	velocity = move_and_slide(velocity,Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func interact(event,player):
	if event.is_action_pressed("interact"):
		if !open:
			var dialog = dialog_scene.instance()
			dialog.story_resource =dialog_story_resource
			dialog.story_title = dialog_title
			dialog.speaker = self
			dialog.player = player
			player.user_interface.show_dialog(dialog,self)
		




func _on_ChestZone_body_entered(body):
	if body.has_method("add_interactive"):
		body.add_interactive(self)


func _on_ChestZone_body_exited(body):
	if body.has_method("remove_interactive"):
		body.remove_interactive(self)
		
	pass # Replace with function body.

