extends Resource
class_name SpawnCommand


@export var name: String
@export var commands: Array[String]
@export var cost: int
@export var spawnedObject: PackedScene
@export var numberSpawned: int
@export var startsActive = true
@export var description = ""

var isActive = true
var viewport: Viewport

func getCurrentCost() -> int:
	var currentLevel: LevelDefinition = LevelManager.getLatest()
	var discountAmount = currentLevel.discountedCommands.count(self)
	
	return cost - discountAmount
