extends CanvasLayer
var InventoryHover= load("res://scenes/InventoryHover.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.user_interface=self
#	print(String([1,2,3]+[]))
#	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("inventory"):
		for inventory_ui in $Control.get_children():
			inventory_ui.visible=!inventory_ui.visible
			inventory_ui.init_inventory();
#		$InventoryUI.visible=!$InventoryUI.visible
#		$InventoryUI.init_inventory();
		
func show_inventory_ui(inventory_ui,interactive):
	interactive.open= true
	inventory_ui.visible=true
#	inventory_ui.get_parent().remove_child(inventory_ui)
	$Control.add_child(inventory_ui)
#	add_child(inventory_ui)
func hide_inventory_ui(inventory_ui,interactive):
	interactive.open=false
	inventory_ui.queue_free()

var do_hover_text := false
var hover_text
func show_basic_hover_text(position,text):
#	if do_hover_text:
	if hover_text == null:
		var inv_hov= InventoryHover.instance()	
		add_child(inv_hov)
		inv_hov.global_position= position
		inv_hov.user_interface=self
		inv_hov.set_text(text)
		hover_text=inv_hov
func close_hover():
	hover_text.visible=false
	hover_text.queue_free()
	hover_text=null
	
func play_click():
	print("CLICK")
	$ClickSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
