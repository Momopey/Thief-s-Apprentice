extends Resource
class_name CitizenFocus

var ai #: CitizenAI
var object: Node
var goal

var salience: float setget  _set_salience,_get_salience
func _get_salience():
	return salience
func _set_salience(new_sal:float):
	salience= new_sal
	ai.sort_focuses()

func init(_ai,_goal, _object:Node,_salience:=1): # _ai:CitizenAI
	ai = _ai
	goal = _goal
	object = _object
	salience = _salience
	return self

func _ready():
	pass
func on_add():
	pass
func on_attention_event(attention_event):
	pass
func on_kill():
	pass
