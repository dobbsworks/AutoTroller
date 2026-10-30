extends Node2D

var chunkScenes: Array[PackedScene] = []
var currentWorldTileX = 0.0
@onready var starterChunk : TileMapLayer = $StartChunk1
var chunkList = []
const ENDING_CHUNK = preload("res://world/endingChunk.tscn")
const LEVEL_GOAL = preload("res://entities/collectibles/level_goal.tscn")

@export var level1Chunks: Array[PackedScene]

var chunksDone = false


func _ready() -> void:
	GameState.stage.levelScene = get_parent()
	currentWorldTileX = starterChunk.get_used_rect().size.x
	LoadAllChunks()
	AppendRandomChunk()

func _process(delta: float) -> void:
	var rightmostCameraEdge = GameState.shared.camera.camera_edge.global_position.x
	var leftmostCameraEdge = GameState.shared.camera.camera_edge_left.global_position.x
	var worldEdge = currentWorldTileX * 16.0
	
	if rightmostCameraEdge > worldEdge:
		if rightmostCameraEdge >= GameState.stage.endStart:
			if !chunksDone:
				chunksDone = true
				GameState.stage.cameraStop = (currentWorldTileX + 24.0) * 16.0
				AppendChunkScene(ENDING_CHUNK)
				var goal = LEVEL_GOAL.instantiate()
				add_sibling(goal)
				goal.global_position = Vector2(GameState.stage.cameraStop, -96.0)
		else:
			AppendRandomChunk()
		
	for chunkObj in chunkList:
		if chunkObj.xRight < leftmostCameraEdge:
			chunkObj.node.queue_free()
			chunkList.erase(chunkObj)

func LoadAllChunks():
	chunkScenes = level1Chunks

func AppendRandomChunk():
	AppendChunkScene(chunkScenes.pick_random())

func AppendChunkScene(chunkScene: PackedScene):
	var newChunk = chunkScene.instantiate()
	add_child(newChunk)
	newChunk.position.x = currentWorldTileX * 16.0
	currentWorldTileX += newChunk.get_used_rect().size.x
	chunkList.append({"node": newChunk, "xRight": currentWorldTileX * 16.0})
