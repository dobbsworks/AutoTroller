extends Resource
class_name SpawnCommand


@export var name: String
@export var commands: Array[String]
@export var cost: int
@export var spawnedObject: PackedScene
@export var numberSpawned: int
@export var isActive = true

var viewport: Viewport
