extends KinematicBody2D

const ACCEL = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
const ATTRACT_DIST= 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var inventory_ui_scene
export(NodePath) var inventory_path
var open = false
var user_interface
var inventory_ui

func inventory_source():
	return get_node(inventory_path)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2(0,MAX_SPEED),ACCEL*delta)
	velocity = move_and_slide(velocity,Vector2.UP)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_ChestZone_body_entered(body):
	if body.has_method("add_interactive"):
		body.add_interactive(self)


func _on_ChestZone_body_exited(body):
	if body.has_method("remove_interactive"):
		body.remove_interactive(self)
		
	pass # Replace with function body.

