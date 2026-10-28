extends Node2D
@onready var dummyCoin: Node2D = $Coin

const COIN = preload("res://entities/collectibles/coin.tscn")
const COIN_FLYING = preload("res://entities/collectibles/coin_flying.tscn")
const COIN_SPIN = preload("res://entities/collectibles/coin_spin.tscn")


var isDummy = false

func _process(delta: float) -> void:
	if isDummy: return
	if dummyCoin:
		dummyCoin.queue_free()
		dummyCoin = null
	[
		spawnRegularCoins,
		spawnFlyingCoins,
		spawnSpinningCoins
	].pick_random().call()
	queue_free()
	
	
	
func spawnRegularCoins():
	# 2x2 coin set
	for xTile in [0,1]:
		for yTile in [0,-1]:
			var coin = COIN.instantiate()
			add_sibling(coin)
			coin.global_position = global_position + 16.0 * Vector2(xTile, yTile)
	
func spawnFlyingCoins():
	# 4 coin set
	for xTile in [0,1,2,3]:
		var coin = COIN_FLYING.instantiate()
		add_sibling(coin)
		coin.global_position = global_position + 16.0 * Vector2(xTile, 0)
		
func spawnSpinningCoins():
	for xTile in [0,1,2,3]:
		var coin = COIN_SPIN.instantiate()
		add_sibling(coin)
		coin.global_position = global_position
		coin.get_node("AutoMoveBehavior").startAge = PI / 4.0 * xTile
