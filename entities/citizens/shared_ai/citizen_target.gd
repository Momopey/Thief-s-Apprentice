extends Resource
class_name CitizenTarget

var ai #: CitizenAI
var goal
var object: Node

func init(_ai,_goal, _object:Node): #:CitizenAI
	ai = _ai
	goal = _goal
	object = _object
	return self
	
var prominence: float

func on_physics_process(delta):
	pass
	
func on_process(delta):
	pass

func on_activate():
	pass

func on_attention_event(attention_event):
	pass

# A process that is called when a target exeeds the current target in prominence
func kill_with(replacement_targ):
	kill()
	pass

func kill():
	print("Killing target")
	on_kill()
	ai.erase_target(self)
	
	
func on_kill():
	pass
