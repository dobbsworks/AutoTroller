extends Node

@export var levelDefinitions: Array[LevelDefinition] = []


var shuffledDefs = []
var chosenPath = []

func _ready():
	shufflePath()

func shufflePath():
	var tempLevelDefList = levelDefinitions.duplicate()
	chosenPath = [tempLevelDefList[0]]
	shuffledDefs = []
	shuffledDefs.append([tempLevelDefList.pop_front()])
	shuffledDefs.append([tempLevelDefList.pop_front()])
	var randomizedSet = []
	for i in range(8):
		randomizedSet.append(tempLevelDefList.pop_front())
	randomizedSet.shuffle()
	shuffledDefs.append([randomizedSet.pop_front(), randomizedSet.pop_front()])
	shuffledDefs.append([randomizedSet.pop_front(), randomizedSet.pop_front()])
	shuffledDefs.append([randomizedSet.pop_front(), randomizedSet.pop_front()])
	shuffledDefs.append([randomizedSet.pop_front(), randomizedSet.pop_front()])
	shuffledDefs.append([tempLevelDefList.pop_front()])
	shuffledDefs.append([tempLevelDefList.pop_front()])
	
func getLatest() -> LevelDefinition:
	if chosenPath.size() > 0:
		return chosenPath[-1]
	return levelDefinitions[0]
	
func getDefinitionOptions(levelNumber: int) -> Array[LevelDefinition]:
	var ret: Array[LevelDefinition] = []
	ret.assign(shuffledDefs[levelNumber - 1])
	return ret
	
func setSelected(levelNumber: int, optionIndex: int) -> void:
	chosenPath.append(shuffledDefs[levelNumber - 1][optionIndex])
