extends Node


var stage = {
	goalDistance = 3200,
	currentScrollSpeed = 4.0,
}

var round = {
	coins = 0,
	lives = 5,
}

var shared = {
	player = null,
	camera = null
}


func _process(delta: float) -> void:
	shared.camera.speed = stage.currentScrollSpeed * 16.0
	
