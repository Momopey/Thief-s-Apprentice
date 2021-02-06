extends KinematicBody2D

var ChestInteractiveClass = preload("res://entities/chests/ChestInteractive.gd")
export(NodePath) var UI_path;
var user_interface

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ACCEL= 960
const MAX_SPEED= 955
const FRICT= 900
var velocity = Vector2.ZERO
var interactives = []

func add_interactive(interactive):
	interactives.append(interactive)
	
func remove_interactive(interactive):
	if interactives.has(interactive):
		interactives.erase(interactive)
		if interactive is ChestInteractiveClass :
			if interactive.open: 
				user_interface.hide_inventory_ui(interactive.inventory_ui,interactive)

onready var sprite = $Sprite
# Called when the node enters the scene tree for the first time.
var _timer
func _ready():

	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.set_wait_time(0.05)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	user_interface= get_node(UI_path)
#	pass # Replace with function body.
func _on_timer_timeout():
	PlayerInventory.do_physics()	
	pass

func _physics_process(delta):
	var input_x= Input.get_action_strength("ui_right")- Input.get_action_strength("ui_left")
	if input_x!=0:
		velocity= velocity.move_toward(Vector2(input_x,0)*MAX_SPEED,ACCEL*delta)
	else: 
		velocity= velocity.move_toward(Vector2.ZERO,FRICT*delta)
		
	velocity= move_and_slide(velocity,Vector2.UP)
		
func _input(event):
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size()>0:
			var pickup_item= $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
	if event.is_action_pressed("interact"):
		for interactive in interactives:
			if interactive is ChestInteractiveClass:
				if !interactive.open:
					print("INTERACTED NEAR CHEST")
					var chest_inventory_ui=interactive.inventory_ui_scene.instance()
					interactive.inventory_ui=chest_inventory_ui
	#				print(interactive.inventory_source())
					chest_inventory_ui.inventory=interactive.inventory_source()
	#				chest_inventory_ui.user_interface = user_interface
					user_interface.show_inventory_ui(chest_inventory_ui,interactive)
				else: 
					user_interface.hide_inventory_ui(interactive.inventory_ui,interactive)
		
			

func get_inventory():
	return PlayerInventory

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PickupZone.items_in_range.size()>0:
			var pickup_item= $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
#	pass
