extends Node

@export var levelDefinitions: Array[LevelDefinition] = []


var shuffledDefs = []
var chosenPath = []

func shufflePath():
	chosenPath = [levelDefinitions[0]]
	shuffledDefs = []
	shuffledDefs.append([levelDefinitions.pop_front()])
	shuffledDefs.append([levelDefinitions.pop_front()])
	var randomizedSet = []
	for i in range(8):
		randomizedSet.append(levelDefinitions.pop_front())
	randomizedSet.shuffle()
	shuffledDefs.append([randomizedSet.pop_front(), randomizedSet.pop_front()])
	shuffledDefs.append([randomizedSet.pop_front(), randomizedSet.pop_front()])
	shuffledDefs.append([randomizedSet.pop_front(), randomizedSet.pop_front()])
	shuffledDefs.append([randomizedSet.pop_front(), randomizedSet.pop_front()])
	shuffledDefs.append([levelDefinitions.pop_front()])
	shuffledDefs.append([levelDefinitions.pop_front()])
	
func getLatest() -> LevelDefinition:
	return chosenPath[-1]
	
func getDefinitionOptions(levelNumber: int) -> Array[LevelDefinition]:
	return shuffledDefs[levelNumber - 1]
	
func setSelected(levelNumber: int, optionIndex: int) -> void:
	chosenPath.append(shuffledDefs[levelNumber - 1][optionIndex])
