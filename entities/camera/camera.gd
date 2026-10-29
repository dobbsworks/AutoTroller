extends Camera2D


@export var direction: Vector2 = Vector2(1, 0)
@export var speed = 4.0
@onready var camera_edge: Node2D = $CameraEdge
@onready var camera_edge_left: Node2D = $CameraEdgeLeft

func _ready() -> void:
	GameState.shared.camera = self 


func _process(delta: float) -> void:
	position += delta * speed * direction
	if GameState.stage.cameraStop > -1:
		var maxCamX = GameState.stage.cameraStop
		if position.x > maxCamX: 
			position.x = maxCamX
			GameState.stage.done = true
