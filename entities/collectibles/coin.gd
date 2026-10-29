extends Node2D

var isDummy = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameState.round.coins += 1
	GameState.stage.coinsThisStage += 1
	queue_free()
