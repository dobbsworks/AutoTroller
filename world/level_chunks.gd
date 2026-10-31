extends Node2D

var chunkScenes: Array[PackedScene] = []
var currentWorldTileX = 0.0
var starterChunk : TileMapLayer
var chunkList = []
const ENDING_CHUNK = preload("res://world/endingChunk.tscn")
const LEVEL_GOAL = preload("res://entities/collectibles/level_goal.tscn")

@export var levelDefintions: Array[LevelDefinition]
var levelDefintion: LevelDefinition
var chunksDone = false


func _ready() -> void:
	levelDefintion = levelDefintions[posmod(GameState.round.currentStage - 1, levelDefintions.size())]
	if levelDefintion.backdrop:
		var backdrop = levelDefintion.backdrop.instantiate()
		add_child(backdrop)
	if levelDefintion.music:
		var audioPlayer = AudioStreamPlayer.new()
		audioPlayer.stream = levelDefintion.music
		audioPlayer.autoplay = true
		audioPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
		audioPlayer.bus = AudioServer.get_bus_name(2)
		add_child(audioPlayer)
	GameState.stage.levelScene = get_parent()
	AppendChunkScene(levelDefintion.startingChunk)
	LoadAllChunks()

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
	chunkScenes = levelDefintion.chunks

func AppendRandomChunk():
	AppendChunkScene(chunkScenes.pick_random())

func AppendChunkScene(chunkScene: PackedScene):
	var newChunk: TileMapLayer = chunkScene.instantiate()
	add_child(newChunk)
	newChunk.position.x = currentWorldTileX * 16.0
	currentWorldTileX += newChunk.get_used_rect().size.x
	chunkList.append({"node": newChunk, "xRight": currentWorldTileX * 16.0})
	DecorateTileMap(newChunk)

func DecorateTileMap(tilemaplayer: TileMapLayer):
	var cellCoordinates = tilemaplayer.get_used_cells()
	for cellCoordinate in cellCoordinates:
		var atlasCoords: Vector2i = tilemaplayer.get_cell_atlas_coords(cellCoordinate)
		if atlasCoords:
			atlasCoords.y += 2 * levelDefintion.offsetIndex
			tilemaplayer.set_cell(cellCoordinate, 0, atlasCoords)
	for child in tilemaplayer.get_children():
		if child is TileMapLayer:
			DecorateTileMap(child)
	
