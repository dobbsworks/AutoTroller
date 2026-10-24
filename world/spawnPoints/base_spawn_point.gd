extends Node2D

@export var spawnables: Array[PackedScene] = []

func _ready() -> void:
	spawnItem()
	queue_free()


func spawnItem():
	if spawnables.size() > 0: 
		var itemScene = spawnables[0]
		var item = itemScene.instantiate()
		add_sibling(item)
		item.position = position
