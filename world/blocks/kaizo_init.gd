extends Node2D
@onready var dummyBlock: Node2D = $SolidBlock

var isDummy = false

func _process(delta: float) -> void:
	if isDummy: return
	if dummyBlock:
		dummyBlock.queue_free()
		dummyBlock = null
		
	queue_free()
