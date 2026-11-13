extends Resource
class_name LevelDefinition

@export var name: String
@export var description: String
@export var groundColor: Color
@export var offsetIndex: int
@export var startingChunk: PackedScene
@export var backdrop: PackedScene
@export var chunks: Array[PackedScene]

@export var music: AudioStream


# Gimmicks
@export var spawnSwaps: Array[SpawnSwap] = []
@export var discountedCommands: Array[SpawnCommand] = []
@export var doubledEnemies: Array[PackedScene] = []
@export_range(0.0, 0.9, 0.1) var slipperiness: float = 0.0
@export_range(-200.0, 200, 10) var wind: float = 0.0
@export var isDark = false
