extends Resource
class_name CitizenFocus

var ai #: CitizenAI
var object: Node
var goal

var salience: float

func init(_ai,_goal, _object:Node,_salience:=1): # _ai:CitizenAI
	ai = _ai
	goal = _goal
	object = _object
	salience = _salience
	return self

func _ready():
	pass

func on_attention_event(attention_event):
	pass
