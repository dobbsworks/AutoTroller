extends Node2D

@export var spawnables: Array[PackedScene] = []

func _ready() -> void:
	checkForSpawn()
	queue_free()


func checkForSpawn():
	var spawnedItem: SpawnResult = MultiplayerHandler.attemptSpawn(spawnables)
	if spawnedItem != null:
		var item = spawnItem(spawnedItem)
			
		# handle doubled enemies
		var levelDef: LevelDefinition = GameState.shared.levelDefinition
		if levelDef:
			for doubledEnemy: PackedScene in levelDef.doubledEnemies:
				if spawnedItem.spawnable == doubledEnemy:
					# create second copy
					var item2 = spawnItem(spawnedItem)
					item2.global_position += Vector2.UP * 32.0


func spawnItem(spawnResult: SpawnResult) -> Node2D:
	var itemScene = spawnResult.spawnable
	var item = itemScene.instantiate()
	get_parent().add_sibling(item)
	if 'chatter' in item:
		item.chatter = spawnResult.chatter
	item.global_position = global_position
	if 'spawnOffset' in item:
		item.global_position += item.spawnOffset
	return item
