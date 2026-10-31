extends Node

var state = "wait"
var pauseTimer = 0.0
@onready var wallop_enemy: Enemy = $".."
@onready var crash: AudioStreamPlayer = $Crash

func _process(delta: float) -> void:
	if wallop_enemy.isDummy:
		wallop_enemy.scale = Vector2.ONE * 0.5
		return
	if state == "wait":
		if GameState.shared.player:
			var horizDistance = abs(wallop_enemy.global_position.x - GameState.shared.player.global_position.x)
			if horizDistance < 64.0:
				state = "falling"
				wallop_enemy.global_position.y = -250
	if state == "falling":
		wallop_enemy.velocity.y = 250.0
		if wallop_enemy.is_on_floor():
			GameState.shared.camera.shake()
			wallop_enemy.velocity.y = 0.0
			state = "pause"
			crash.play()
			pauseTimer = 1.5
	if state == "pause":
		pauseTimer = move_toward(pauseTimer, 0.0, delta)
		if pauseTimer <= 0.0:
			state = "rising"
	if state == "rising":
		wallop_enemy.velocity.y = -100.0
		if wallop_enemy.global_position.y <= -300.0:
			state = "wait"
