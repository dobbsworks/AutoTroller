extends Node2D


@export var direction: Vector2 = Vector2(1, 0)
@export var speed = 4.0
@onready var camera_edge: Node2D = $CameraEdge
@onready var camera_edge_left: Node2D = $CameraEdgeLeft
@onready var horizontal_camera: Camera2D = $HorizontalCamera

var shakeTimer = 0.0


func _ready() -> void:
	GameState.shared.camera = self 


func _process(delta: float) -> void:
	shakeTimer = move_toward(shakeTimer, 0.0, delta)
	if shakeTimer == 0:
		horizontal_camera.position = Vector2.ZERO
	else:
		horizontal_camera.position = Vector2(randf_range(-1,1), randf_range(-1,1)) * 2.0
	position += delta * speed * direction
	if GameState.stage.cameraStop > -1:
		var maxCamX = GameState.stage.cameraStop
		if position.x > maxCamX: 
			position.x = maxCamX
			GameState.stage.done = true

func shake():
	shakeTimer = 0.3
