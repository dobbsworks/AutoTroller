extends Node2D

var chunkScenes: Array[PackedScene] = []
var currentWorldTileX = 0.0
@onready var starterChunk : TileMapLayer = $TileMapLayer
@export var camera: Camera2D
var chunkList = []

func _ready() -> void:
	currentWorldTileX = starterChunk.get_used_rect().size.x
	LoadAllChunks()
	AppendRandomChunk()

func _process(delta: float) -> void:
	var rightmostCameraEdge = camera.camera_edge.global_position.x
	var leftmostCameraEdge = camera.camera_edge_left.global_position.x
	var worldEdge = currentWorldTileX * 16.0
	
	if rightmostCameraEdge > worldEdge:
		AppendRandomChunk()
		
	for chunkObj in chunkList:
		if chunkObj.xRight < leftmostCameraEdge:
			chunkObj.node.queue_free()
			chunkList.erase(chunkObj)

func LoadAllChunks():
	var chunkDirectory = "res://world/levelChunks/"
	var dir = DirAccess.open(chunkDirectory)
	dir.list_dir_begin()
	var fileNames = []
	var fileName = dir.get_next()
	while fileName != "":
		if fileName.ends_with(".tscn"):
			fileNames.append(chunkDirectory.path_join(fileName))
		fileName = dir.get_next()
	for fileName1 in fileNames:
		chunkScenes.append(load(fileName1))

func AppendRandomChunk():
	var newChunk = chunkScenes.pick_random().instantiate()
	add_child(newChunk)
	newChunk.position.x = currentWorldTileX * 16.0
	currentWorldTileX += newChunk.get_used_rect().size.x
	chunkList.append({"node": newChunk, "xRight": currentWorldTileX * 16.0})
