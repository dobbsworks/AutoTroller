extends Node2D

@export var spawnables: Array[PackedScene] = []

func _ready() -> void:
	checkForSpawn()
	queue_free()


func checkForSpawn():
	var spawnedItem = MultiplayerHandler.attemptSpawn(spawnables)
	if spawnedItem != null:
		spawnItem(spawnedItem)


func spawnItem(itemScene: PackedScene):
		var item = itemScene.instantiate()
		add_sibling(item)
		item.position = position
