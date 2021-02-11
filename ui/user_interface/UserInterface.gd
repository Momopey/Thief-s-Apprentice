extends CanvasLayer
var InventoryHover= load("res://ui/inventory_hover/InventoryHover.tscn")
var InventoryUIClass = load("res://ui/inventories/InventoryUI.gd")

export(NodePath) var player_path
var player
export(NodePath) var client_path
var client

var visible:= false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player= get_node(player_path)
	client= get_node(client_path)
#	for inventory_ui in $Control.get_children():
#		if inventory_ui is InventoryUIClass:
#			inventory_ui.inventory = player
#	print(String([1,2,3]+[]))
#	pass # Replace with function body.
func get_client():
	return get_node(client_path)

func _input(event):
	if client.is_client():
		if event.is_action_pressed("inventory"):
			set_visible(!visible)
				
func set_visible(vis:bool):
	visible=vis
	for inventory_ui in $Control.get_children():
		if inventory_ui is InventoryUI:
			inventory_ui.visible= visible
			if inventory_ui is InventoryUIClass:
				inventory_ui.init_inventory();
#		$InventoryUI.visible=!$InventoryUI.visible
#		$InventoryUI.init_inventory();
		
func show_inventory_ui(inventory_ui,interactive):
	player.interactive_ui = inventory_ui
	inventory_ui.inventory=interactive.inventory_source()
	inventory_ui.ui = player.user_interface
	interactive.open= true
	inventory_ui.visible=true
#	inventory_ui.get_parent().remove_child(inventory_ui)
	$Control.add_child(inventory_ui)
#	add_child(inventory_ui)
func hide_inventory_ui(inventory_ui,interactive):
	interactive.open=false
	if inventory_ui:
		inventory_ui.queue_free()
		
func show_dialog(dialog,interactive):
	if player.dialog:
		hide_dialog(player.dialog,player.dialog_source)
	interactive.open= true
	player.dialog= dialog;
	player.dialog_source = interactive;
#	dialog.visible=true
	$Control.add_child(dialog)
	
func hide_dialog(dialog,interactive):
	interactive.open= false
	if player.dialog == dialog:
		player.dialog = null
		player.dialog_source= null
#	dialog.visible=false
	if dialog:
		dialog.queue_free()

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
