extends Resource
class_name AttentionEvent

var object: Node
var subject: Node
var disruption: int

func init(_object:Node,_subject:Node,_disruption :int):
	object = _object
	subject = _subject
	disruption= _disruption
	return self

func _ready():
	pass
