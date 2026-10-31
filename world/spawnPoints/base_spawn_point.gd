extends Node2D

@export var spawnables: Array[PackedScene] = []

func _ready() -> void:
	checkForSpawn()
	queue_free()


func checkForSpawn():
	var spawnedItem: SpawnResult = MultiplayerHandler.attemptSpawn(spawnables)
	if spawnedItem != null:
		spawnItem(spawnedItem)


func spawnItem(spawnResult: SpawnResult):
	var itemScene = spawnResult.spawnable
	var item = itemScene.instantiate()
	get_parent().add_sibling(item)
	if 'chatter' in item:
		item.chatter = spawnResult.chatter
	item.global_position = global_position
	if 'spawnOffset' in item:
		item.global_position += item.spawnOffset
