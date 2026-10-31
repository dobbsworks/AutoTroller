extends Node2D
const COIN_SOUND = preload("res://entities/collectibles/coin_sound.tscn")

var isDummy = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameState.round.coins += 1
	GameState.round.totalCoins += 1
	GameState.stage.coinsThisStage += 1
	
	var coin: AudioStreamPlayer = COIN_SOUND.instantiate()
	add_sibling(coin)
	coin.finished.connect(coin.queue_free)
	queue_free()
