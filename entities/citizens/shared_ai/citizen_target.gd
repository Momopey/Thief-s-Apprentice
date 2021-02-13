extends Resource
class_name CitizenTarget

var ai #: CitizenAI
var goal
var object: Node
var focus

func init(_ai,_goal,_focus): #:CitizenAI
	ai = _ai
	goal = _goal
	object = _focus.object
	focus = _focus
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

func replace_with(replacement_targ):
	ai.pass_target(self)
	pass

# A process that is called when a target exeeds the current target in prominence
func kill_with(replacement_targ):
	kill()
	pass

func kill():
	on_kill()
	ai.erase_target(self)
	
	
func on_kill():
	pass
