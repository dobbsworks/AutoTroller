extends Node2D


func _ready() -> void:
	var levelDef: LevelDefinition = GameState.shared.levelDefinition
	if levelDef:
		visible = levelDef.isDark
