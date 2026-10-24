extends Camera2D


@export var direction: Vector2 = Vector2(1, 0)
@export var speed = 4.0
@onready var camera_edge: Node2D = $CameraEdge
@onready var camera_edge_left: Node2D = $CameraEdgeLeft

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	position += delta * speed * direction
