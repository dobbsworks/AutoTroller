extends Node2D

@export var spawnables: Array[PackedScene] = []

func _ready() -> void:
	checkForSpawn()
	queue_free()


func checkForSpawn():
	var spawnedItem = MultiplayerHandler.attemptSpawn(spawnables)
	if spawnedItem != null:
		spawnItem(spawnedItem.spawnable)


func spawnItem(itemScene: PackedScene):
		var item = itemScene.instantiate()
		get_parent().add_sibling(item)
		item.global_position = global_position
