extends Node
const GAME = preload("res://game.tscn")


var defaultStage = {
	endStart = 10,
	goalDistance = -1,
	cameraStop = -1,
	currentScrollSpeed = 4.0,
	done = false,
	coinsThisStage = 0,
	deathsThisStage = 0,
	levelScene = null,
} 
var stage = {}

var defaultRound = {
	coins = 0,
	lives = 2,
	deaths = 0,
	currentStage = 1,
}
var round = {}

var shared = {
	player = null,
	camera = null
}

var stagesPerRound = 2


func _ready() -> void:
	resetGame()

func _process(delta: float) -> void:
	if shared.camera: 
		shared.camera.speed = stage.currentScrollSpeed * 16.0
		stage.goalDistance = stage.endStart + 16.0 * 29

func getGoalRegionRect() -> Rect2:
	var endIconXs = [16, 48, 80, 112, 144, 176]
	var iconIndex = posmod(round.currentStage, [16, 48, 80, 112, 144, 176].size())
	return Rect2(endIconXs[iconIndex], 48, 16, 16)
	
func resetGame():
	Utility.copyObj(defaultStage, stage)
	Utility.copyObj(defaultRound, round)
	
	
func createNewLevel():
	MultiplayerHandler.isActive = true
	GameState.stage.done = false
	Utility.copyObj(defaultStage, stage)
	var newStage = GAME.instantiate()
	add_sibling(newStage)
	
