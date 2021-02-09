extends Resource
class_name CitizenGoal

var ai #: CitizenAI
var influence: float

func init(_ai):
	ai = _ai


# node_to_focus: ALL CITIZEN GOALS MUST IMPLEMENT THIS METHOD.
# When a node enters focus areas, it must be chosen to be focused on or ignored
# node_to_focus takes Node, and returns a CitizenFocus, with required context is the node is to be focused on, return null otherwise
func node_to_focus(object:Node,attention_event):
	printerr("Node to focus for Citizen Goal:",get_class()," : Must implement")
	return null

func focused_event_to_target(focus,attention_event): # -> CitizenTarget
	return null 

func _ready():
	pass
