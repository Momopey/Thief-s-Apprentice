extends AttentionEvent
class_name InteractChestAttentionEvent

enum InteractionType {
	OPEN,
	MODIFY,
	CLOSE,
}
var interaction # : InteractionType
var actor 

func init_2(_interaction : int, _actor : Node):
	interaction = _interaction 
	actor = _actor
	return self

func _ready():
	pass
